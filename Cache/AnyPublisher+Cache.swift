import Combine
import Foundation

extension Publisher<Data, Error> {
    
    /// This stores a publisher's latest element to a cache.
    /// If the cache has a miss then only the upstream elements are published.
    /// If the cache has a hit then the cache's element is published and then the upstream's element follows.
    /// If for some reason the upstream publisher produces an element before the cache produces it's element, the cache's element is ignored (not published).
    /// The cache never emits any errors.
    /// The upstream publisher's errors are emitted but only if the cache hasn't emitted any elements. If it has, then this publisher finishes without an error.
    public func cache(_ cache: PublisherCaching) -> AnyPublisher<Data, Error> {
        let upstream = self.share()
        cache.cacheElements(from: upstream)
        
        let cachePublisher = cache.cachedDataPublisher
            .ignoreError() // We don't care about errors due to a cache misses.
            .prefix(untilOutputFrom: upstream) // Only emit cached elements before the upstream publisher emits any elements.
        
        var hasEmittedElement = false
        return cachePublisher
            .merge(with: upstream)
            .handleEvents(receiveOutput: { _ in
                hasEmittedElement = true
            })
            .tryCatch { error in
                // If we have emitted an element we should ignore all errors and finish normally.
                guard hasEmittedElement else {
                    throw error
                }
                NSLog(error.localizedDescription)
                return Empty<Data, Error>()
            }
            .eraseToAnyPublisher()
    }
}

private extension Publisher {
    /// This ignores errors from a publisher without changing the failure type to `Never`.
    func ignoreError() -> AnyPublisher<Output, Failure> {
        map { Optional($0) }
        .replaceError(with: nil)
        .compactMap { $0 }
        .setFailureType(to: Failure.self)
        .eraseToAnyPublisher()
    }
}
