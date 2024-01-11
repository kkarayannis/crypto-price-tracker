import Combine
import Foundation

import PageLoader

final class CoinListViewModel {
    private let coinListLoader: CoinListLoading
    private let settings: Settings
    private let exchangeRates: ExchangeRates
    let pageFactory: PageFactory
        
    let title = "Crypto Prices" // TODO: Localize
    
    @Published private var itemsResult: Result<[CoinListItemViewModel], Error>?
    private var cancellable: AnyCancellable?
    
    init(coinListLoader: CoinListLoading, settings: Settings, exchangeRates: ExchangeRates, pageFactory: PageFactory) {
        self.coinListLoader = coinListLoader
        self.settings = settings
        self.pageFactory = pageFactory
        self.exchangeRates = exchangeRates
    }
    
    lazy var itemsPublisher: AnyPublisher<[CoinListItemViewModel], Never> = $itemsResult
        .removeDuplicates {
            if case .success(let lhs) = $0, case .success(let rhs) = $1 {
                return lhs == rhs
            }
            return false
        }
        .compactMap { result in
            switch result {
            case .success(let items):
                return items
            case .failure, .none:
                return nil
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    
    lazy var pageStatePublisher: AnyPublisher<PageLoaderState, Never> = $itemsResult
        .tryCompactMap { result in
            switch result {
            case .success(let items):
                return items
            case .failure(let error):
                throw error
            case .none:
                return nil
            }
        }
        .map { _ in .loaded } // If we receive any element, we consider the page loaded.
        .removeDuplicates()
        .replaceError(with: .error)
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    
    func loadCoins() {
        exchangeRates.loadRates()
        cancellable = coinListLoader.loadingPublisher
            .receive(on: DispatchQueue.main)
            .map { [weak self] coins in
                guard let self else {
                    return []
                }
                return self.items(from: coins)
            }
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let failure) = completion {
                    NSLog(failure.localizedDescription)
                    self?.itemsResult = .failure(failure)
                }
            }, receiveValue: { [weak self] items in
                self?.itemsResult = .success(items)
            })
    }
    
    private func items(from coins: [Coin]) -> [CoinListItemViewModel] {
        coins.map { coin in
            CoinListItemViewModel(settings: settings, exchangeRates: exchangeRates, coin: coin)
        }
    }
    
    #if DEBUG
    // Used for Previews only
    func __setItems(_ items: [CoinListItemViewModel]) {
        itemsResult = .success(items)
    }
    #endif
}
