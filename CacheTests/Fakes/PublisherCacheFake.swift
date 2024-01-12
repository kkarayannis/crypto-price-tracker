import Combine
import XCTest

import Cache

final class PublisherCacheFake: PublisherCaching {
    
    var cancellable: AnyCancellable?
    
    var expectationToFulfill: XCTestExpectation?
    var cachedElement: Data?
    func cacheElements(from publisher: some Publisher<Data, Error>) {
        cancellable = publisher.sink(receiveCompletion: { _ in }, receiveValue: { [weak self] element in
            self?.expectationToFulfill?.fulfill()
            self?.cachedElement = element
        })
    }
    
    var elementToReturn: Data?
    var cachedDataPublisher: any Publisher<Data, Error> {
        if let elementToReturn {
            return Just(elementToReturn)
                .setFailureType(to: Error.self)
        } else {
            return Empty<Data, Error>()
        }
    }
    
    
}
