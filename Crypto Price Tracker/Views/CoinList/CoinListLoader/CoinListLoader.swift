import Combine
import Foundation

import Cache
import DataLoader

/// Loads the coin information from the network
protocol CoinListLoading {
    var loadingPublisher: AnyPublisher<[Coin], Error> { get }
}

enum CoinListLoaderError: Error {
    case invalidURL
    case networkError
}

final class CoinListLoader: CoinListLoading {
    private static let coinListCacheKey = "coinList"
    private let dataLoader: DataLoading
    private let cache: Caching
    
    init(dataLoader: DataLoading, cache: Caching) {
        self.dataLoader = dataLoader
        self.cache = cache
    }
    
    var loadingPublisher: AnyPublisher<[Coin], Error> {
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
            .cache(PublisherCache(key: Self.coinListCacheKey.toBase64(), cache: cache))
            .tryMap {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                // Assuming 1 USDT == 1 USD, we can get the prices in USDT.
                let coinsInUSDT = try decoder.decode([Coin].self, from: $0)
                    .filter { $0.quoteAsset.hasSuffix("usdt") }
                return coinsInUSDT
            }
            .eraseToAnyPublisher()
    }
    
    
}

private enum Endpoint {
    private static let urlString = "https://api.wazirx.com/sapi/v1/tickers/24hr"
    
    static var url: URL? {
        URL(string: urlString)
    }
}
