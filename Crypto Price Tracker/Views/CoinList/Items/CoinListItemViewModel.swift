import Combine

final class CoinListItemViewModel: Identifiable, Equatable, ObservableObject {
    private let settings: Settings
    let name: String
    private let price: Double?
    @Published var priceInCurrency: String?
    
    private var cancellable: AnyCancellable?
    
    init(settings: Settings, name: String, price: String) {
        self.settings = settings
        self.name = name
        self.price = Double(price)
        
        calculatePriceInCurrency(settings.currency)
        subscribeToCurrencyChanges()
    }
    
    private func subscribeToCurrencyChanges() {
        cancellable = settings.$currency
            .sink { [weak self] currency in
                self?.calculatePriceInCurrency(currency)
            }
    }
    
    private func calculatePriceInCurrency(_ currency: Currency) {
        guard let price else {
            return
        }
        let adjustedPrice = currency == .usd ? price : price * 10
        priceInCurrency = String(adjustedPrice)
    }
    
    static func == (lhs: CoinListItemViewModel, rhs: CoinListItemViewModel) -> Bool {
        lhs.name == rhs.name &&
        lhs.price == rhs.price
    }
    
//    #if DEBUG
//    static var example: Self {
//        self.init(
//            title: "Title",
//            id: "id",
//            authors: "Authors",
//            year: "2004",
//            coverViewModel: CoverViewModel.example
//        )
//    }
//    #endif
}
