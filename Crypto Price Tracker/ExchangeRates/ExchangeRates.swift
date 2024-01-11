import Combine

final class ExchangeRates {
    private let exchangeRateLoader: ExchangeRateLoader
    
    @Published var rates: CurrencyExchangeRate?
    
    private var cancellable: AnyCancellable?
    
    init(exchangeRateLoader: ExchangeRateLoader) {
        self.exchangeRateLoader = exchangeRateLoader
    }
    
    func loadRates() {
        cancellable = exchangeRateLoader.loadingPublisher
            .sink(receiveCompletion: { _ in }, receiveValue: { [weak self] in
                self?.rates = $0
            })
    }
}
