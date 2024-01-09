import Combine
import Foundation

enum PublisherCacheError: Error {
    case noDataForKey
}

/// Caches elements from a publisher and produces a publisher for cached elements.
public protocol PublisherCaching {
    func cacheElements(from publisher: some Publisher<Data, Error>)
    var cachedDataPublisher: any Publisher<Data, Error> { get }
}

public final class PublisherCache: PublisherCaching {
    private let key: String
    private let cache: Caching
    
    private var subscription: AnyCancellable?
    
    public init(key: String, cache: Caching = Cache(fileManager: FileManager.default)) {
        self.key = key
        self.cache = cache
    }
    
    public func cacheElements(from publisher: some Publisher<Data, Error>) {
        subscription = publisher
            .sink(receiveCompletion: { completion in }) { element in
                Task {
                    try await self.cache.store(data: element, key: self.key)
                }
            }
    }
    
    public var cachedDataPublisher: any Publisher<Data, Error> {
        Future { promise in
            Task {
                guard let data = try await self.cache.data(for: self.key) else {
                    promise(.failure(PublisherCacheError.noDataForKey))
                    return
                }
                
                promise(.success(data))
            }
        }
    }
}
