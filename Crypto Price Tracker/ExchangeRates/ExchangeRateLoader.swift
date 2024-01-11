import Combine
import Foundation

import Cache
import DataLoader

/// Loads exchange rates from the network
protocol ExchangeRateLoading {
    var loadingPublisher: AnyPublisher<CurrencyExchangeRate, Error> { get }
}

enum ExchangeRateLoaderError: Error {
    case invalidURL
    case networkError
}

final class ExchangeRateLoader: ExchangeRateLoading {
    private static let exchangeRateCacheKey = "exchange-rate"
    private let dataLoader: DataLoading
    private let cache: Caching
    
    init(dataLoader: DataLoading, cache: Caching) {
        self.dataLoader = dataLoader
        self.cache = cache
    }
    
    var loadingPublisher: AnyPublisher<CurrencyExchangeRate, Error> {
        guard let url = Endpoint.url else {
            return Fail(error: CoinListLoaderError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return dataLoader.dataLoadingPublisher(for: url)
            .mapError { error in
                // Handle network error more granularly if needed here.
                NSLog(error.localizedDescription)
                return CoinListLoaderError.networkError
            }
            .cache(PublisherCache(key: Self.exchangeRateCacheKey.toBase64(), cache: cache))
            .tryMap {
                try JSONDecoder().decode(CurrencyExchangeRate.self, from: $0)
            }
            .eraseToAnyPublisher()
    }
    
    
}

private enum Endpoint {
    private static let urlString = "https://cdn.jsdelivr.net/gh/fawazahmed0/currency-api@1/latest/currencies/usd.json"
    
    static var url: URL? {
        URL(string: urlString)
    }
}

struct CurrencyExchangeRate: Decodable {
    let usd: ExchangeRates

    struct ExchangeRates: Decodable {
        // Add more currencies here if needed. 
        let sek: Double
    }
}
