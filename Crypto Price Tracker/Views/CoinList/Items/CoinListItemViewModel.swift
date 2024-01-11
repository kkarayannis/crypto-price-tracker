import Combine

final class CoinListItemViewModel: Identifiable, Equatable, ObservableObject {
    private let settings: Settings
    private let exchangeRates: ExchangeRates
    private let coin: Coin
    @Published var priceInCurrency: String?
    
    private var cancellables = [AnyCancellable]()
    
    init(settings: Settings, exchangeRates: ExchangeRates, coin: Coin) {
        self.settings = settings
        self.exchangeRates = exchangeRates
        self.coin = coin
        
        calculatePriceInCurrency(settings.currency, rates: exchangeRates.rates)
        subscribeToCurrencyChanges()
    }
    
    var name: String {
        coin.baseAsset
    }
    
    private func subscribeToCurrencyChanges() {
        // User-selected currency
        settings.$currency
            .sink { [weak self] currency in
                self?.calculatePriceInCurrency(currency, rates: self?.exchangeRates.rates)
            }
            .store(in: &cancellables)
        
        // Exchange rates
        exchangeRates.$rates
            .sink { [weak self] rates in
                guard let self else {
                    return
                }
                self.calculatePriceInCurrency(self.settings.currency, rates: rates)
            }
            .store(in: &cancellables)
        
    }
    
    private func calculatePriceInCurrency(_ currency: Currency, rates: CurrencyExchangeRate?) {
        guard let price = Double(coin.lastPrice),
        let rates else {
            return
        }
        let adjustedPrice = currency == .usd ? price : price * rates.usd.sek
        priceInCurrency = String(adjustedPrice)
    }
    
    static func == (lhs: CoinListItemViewModel, rhs: CoinListItemViewModel) -> Bool {
        lhs.coin == rhs.coin
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
