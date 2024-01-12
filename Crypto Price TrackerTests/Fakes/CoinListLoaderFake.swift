@testable import Crypto_Price_Tracker

import Combine
import XCTest

final class CoinListLoaderFake: CoinListLoading {
    
    var coins: [Coin]?
    var error: Error?
    var loadingPublisher: AnyPublisher<[Coin], Error> {
        guard coins != nil || error != nil else {
            XCTFail("Both coins and error are nil")
            return Empty<[Coin], Error>()
                .eraseToAnyPublisher()
        }
        
        if let error {
            return Fail(error: error)
                .eraseToAnyPublisher()
        } else if let coins {
            return Just(coins)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        return Empty<[Coin], Error>()
            .eraseToAnyPublisher()
    }
}
