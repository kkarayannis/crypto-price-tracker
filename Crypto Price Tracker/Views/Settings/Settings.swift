import Foundation

enum Currency: String, Codable, CaseIterable, Identifiable {
    case usd = "USD"
    case sek = "SEK"
    
    var id: String {
        rawValue
    }
    
    static var `default`: Self {
        // Use USD for everyone except people with a Swedish locale.
        Locale.current.identifier == "sv_SE" ? .sek : .usd
    }
}

final class Settings: ObservableObject {
    private static let currencyKey = "settings:currency"
    
    @Published var currency: Currency {
        didSet {
            guard let data = try? JSONEncoder().encode(currency) else {
                return
            }
            userDefaults.setValue(data, forKey: Self.currencyKey)
        }
    }
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults) {
        if let data = userDefaults.data(forKey: Self.currencyKey),
           let currency = try? JSONDecoder().decode(Currency.self, from: data) {
            self.currency = currency
        } else {
            currency = .default
        }
        
        self.userDefaults = userDefaults
    }
}
