@testable import Crypto_Price_Tracker

import Combine
import XCTest

final class CoinListLoaderTests: XCTestCase {
    
    // Unit under test
    var coinListLoader: CoinListLoader!
    
    // Dependencies
    var dataLoaderFake: DataLoaderFake!
    var cacheFake: CacheFake!
    
    var cancellable: AnyCancellable?

    override func setUp() {
        super.setUp()
        dataLoaderFake = DataLoaderFake()
        cacheFake = CacheFake()
        coinListLoader = CoinListLoader(dataLoader: dataLoaderFake, cache: cacheFake)
    }
    
    override func tearDown() {
        super.tearDown()
        
        cancellable?.cancel()
    }

    func testLoadingCoinList() throws {
        // Given the data loader has some data
        dataLoaderFake.data = try Helpers.responseData()
        
        // When we load the coin list
        let expectation = expectation(description: "Loading coin list")
        var expectedCoins: [Coin]?
        cancellable = coinListLoader.loadingPublisher
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("We were not expecting an error")
                    expectation.fulfill()
                }
            }, receiveValue: { coins in
                expectedCoins = coins
                expectation.fulfill()
            })
        
        wait(for: [expectation], timeout: 2)
        
        // Then we get some coins
        XCTAssertGreaterThan(expectedCoins?.count ?? 0, 0)
    }
    
    func testLoadingCoinListWithDecodingError() throws {
        // Given the data loader has some bogus data
        dataLoaderFake.data = "these are not the coins you are looking for".data(using: .utf8)
        
        // When we load the coin list
        let expectation = expectation(description: "Loading coin list")
        var expectedError: Error?
        cancellable = coinListLoader.loadingPublisher
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    expectedError = error
                    expectation.fulfill()
                }
            }, receiveValue: { _ in
                XCTFail("We were not expecting a valid object")
                expectation.fulfill()
            })
        
        wait(for: [expectation], timeout: 2)
        
        // Then we get an error
        XCTAssertNotNil(expectedError as? DecodingError)
    }
}
