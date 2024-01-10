import SwiftUI

struct SettingsView: View {
    let settings: Settings
    @State private var currency: Currency = .default
    
    init(settings: Settings) {
        self.settings = settings
    }
    
    var body: some View {
        List {
            CurrencySettingView(currency: $currency)
                .onChange(of: currency) {
                    settings.currency = currency
                }
                .onReceive(settings.$currency) {
                    currency = $0
                }
        }
    }
}

private struct CurrencySettingView: View {
    @Binding var currency: Currency
    
    var body: some View {
        // TODO: localize title
        Picker("Currency", selection: $currency) {
            ForEach(Currency.allCases) { currency in
                Text(currency.rawValue).tag(currency)
            }
        }
    }
}

#Preview {
    SettingsView(settings: Settings(userDefaults: UserDefaults.standard))
}
