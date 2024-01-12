import Combine
import Foundation

import PageLoader

final class CoinDetailViewModel {
    private let coinTimelineLoader: CoinTimelineLoading
    private let settings: Settings
    private let exchangeRates: ExchangeRates
    private let coinName: String
    
    @Published private var priceTimelineResult: Result<[CoinPrice], Error>?
    private var cancellable: AnyCancellable?
    
    var title: String {
        coinName
    }
    
    init(coinTimelineLoader: CoinTimelineLoading, settings: Settings, exchangeRates: ExchangeRates, coinName: String) {
        self.coinTimelineLoader = coinTimelineLoader
        self.settings = settings
        self.exchangeRates = exchangeRates
        self.coinName = coinName
    }
    
    lazy var priceTimelinePublisher: AnyPublisher<[CoinPrice], Never> = $priceTimelineResult
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
    
    lazy var pageStatePublisher: AnyPublisher<PageLoaderState, Never> = $priceTimelineResult
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
    
    func loadTimeline() {
        exchangeRates.loadRates()
        cancellable = coinTimelineLoader.loadingPublisher(for: coinName)
            .tryMap { [weak self] prices in
                if self?.settings.currency == .usd {
                    return prices
                } else {
                    guard let rates = self?.exchangeRates.rates else {
                        throw CoinDetailViewModelError.exchangeRatesNotLoaded
                    }
                    return prices.map {
                        CoinPrice(value: $0.value * rates.usd.sek, timestamp: $0.timestamp)
                    }
                }
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let failure) = completion {
                    NSLog(failure.localizedDescription)
                    self?.priceTimelineResult = .failure(failure)
                }
            }, receiveValue: { [weak self] items in
                self?.priceTimelineResult = .success(items)
            })
    }
    
    private enum CoinDetailViewModelError: Error {
        case exchangeRatesNotLoaded
    }
}
