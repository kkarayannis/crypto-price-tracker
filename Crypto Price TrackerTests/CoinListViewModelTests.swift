@testable import Crypto_Price_Tracker

import Combine
import Foundation
import XCTest

import PageLoader

final class CoinListViewModelTests: XCTestCase {
    
    // Unit under test
    var viewModel: CoinListViewModel!
    
    // Dependencies
    var coinListLoaderFake: CoinListLoaderFake!
    
    var cancellable: AnyCancellable?
    
    override func setUp() {
        super.setUp()
        
        coinListLoaderFake = CoinListLoaderFake()
        viewModel = CoinListViewModel(
            coinListLoader: coinListLoaderFake,
            settings: Settings(userDefaults: UserDefaults.standard),
            exchangeRates: ExchangeRates(exchangeRateLoader: ExchangeRateLoader(
                dataLoader: DataLoaderFake(), 
                cache: CacheFake()
            )),
            pageFactory: PageFactoryFake()
        )
    }
    
    override func tearDown() {
        super.tearDown()
        
        cancellable?.cancel()
    }
    
    func testLoadItems() throws {
        // Given the loader will return some coins
        coinListLoaderFake.coins = try Helpers.responseCoins()
        
        // and that we subscribe to the itemsPublisher
        let expectation = expectation(description: "Loading items")
        var expectedItems: [CoinListItemViewModel]?
        cancellable = viewModel.itemsPublisher
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("We were not expecting an error")
                    expectation.fulfill()
                }
            }, receiveValue: { items in
                expectedItems = items
                expectation.fulfill()
            })
        
        // When we load the coins
        viewModel.loadCoins()
        
        wait(for: [expectation], timeout: 2)
        
        // Then we get some items
        XCTAssertGreaterThan(expectedItems?.count ?? 0, 0)
    }
    
    func testLoadItemsSetsTheStateToLoaded() throws {
        // Given the loader will return some coins
        coinListLoaderFake.coins = try Helpers.responseCoins()
        
        // and that we subscribe to the pageStatePublisher
        let expectation = expectation(description: "Page state loading")
        var expectedState: PageLoaderState?
        cancellable = viewModel.pageStatePublisher
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("We were not expecting an error")
                    expectation.fulfill()
                }
            }, receiveValue: { state in
                expectedState = state
                expectation.fulfill()
            })
        
        // When we load the coins
        viewModel.loadCoins()
        
        wait(for: [expectation], timeout: 2)
        
        // Then we get a loaded state
        XCTAssertEqual(expectedState, .loaded)
    }
    
    func testLoadItemsSetsTheStateToError() throws {
        // Given the loader will produce an error
        coinListLoaderFake.error = TestError.generic
        
        // and that we subscribe to the pageStatePublisher
        let expectation = expectation(description: "Page state loading")
        var expectedState: PageLoaderState?
        cancellable = viewModel.pageStatePublisher
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("We were not expecting an error")
                    expectation.fulfill()
                }
            }, receiveValue: { state in
                expectedState = state
                expectation.fulfill()
            })
        
        // When we load the coins
        viewModel.loadCoins()
        
        wait(for: [expectation], timeout: 2)
        
        // Then we get a loaded state
        XCTAssertEqual(expectedState, .error)
    }
}
