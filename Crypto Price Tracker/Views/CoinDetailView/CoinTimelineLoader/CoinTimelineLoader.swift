import Combine
import Foundation

import Cache
import DataLoader

/// Loads the coin information from the network
protocol CoinTimelineLoading {
    func loadingPublisher(for coinName: String) -> AnyPublisher<[CoinPrice], Error>
}

enum CoinTimelineLoaderError: Error {
    case invalidURL
    case networkError
}

final class CoinTimelineLoader: CoinTimelineLoading {
    private static let coinListCacheKeyPrefix = "coinTimeline"
    private let dataLoader: DataLoading
    private let cache: Caching
    
    init(dataLoader: DataLoading, cache: Caching) {
        self.dataLoader = dataLoader
        self.cache = cache
    }
    
    func loadingPublisher(for coinName: String) -> AnyPublisher<[CoinPrice], Error> {
        guard let url = Endpoint.url(for: coinName) else {
            return Fail(error: CoinListLoaderError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        let cacheKey = (Self.coinListCacheKeyPrefix + coinName)
        return dataLoader.dataLoadingPublisher(for: url)
            .mapError { error in
                // Handle network error more granularly if needed here.
                NSLog(error.localizedDescription)
                return CoinListLoaderError.networkError
            }
            .cache(PublisherCache(key: cacheKey.toBase64(), cache: cache))
            .tryMap {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let data = try decoder.decode([[Double]].self, from: $0)
                return data.compactMap {
                    guard $0.count > 5 else {
                        return nil
                    }
                    return CoinPrice(value: $0[4], timestamp: $0[0])
                }
            }
            .eraseToAnyPublisher()
    }
}

struct CoinPrice: Equatable, Identifiable {
    let value: Double
    let timestamp: Double
    
    var id: Double {
        timestamp
    }
}

private enum Endpoint {
    private static let baseURLString = "https://api.wazirx.com/sapi/v1/klines"
    
    // TODO: Make generic for other parameters
    static func url(for coinName: String) -> URL? {
        let url = URL(string: baseURLString)
        let queryItems = [
            // Assuming 1 USDT == 1 USD, we can get the prices in USDT.
            URLQueryItem(name: "symbol", value: coinName + "usdt"),
            URLQueryItem(name: "limit", value: "30"),
            URLQueryItem(name: "interval", value: "1d")
        ]
        return url?.appending(queryItems: queryItems)
    }
}
