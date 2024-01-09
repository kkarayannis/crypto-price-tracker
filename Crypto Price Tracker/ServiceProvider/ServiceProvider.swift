import Foundation

import Cache
import DataLoader

/// An object that instantiates and holds references to long-living objects.
protocol ServiceProviding {
    func provideDataLoader() -> DataLoading
    func providePageFactory() -> PageFactory
    func provideCache() -> Caching
}

final class ServiceProvider: ServiceProviding {
    private let dataLoader = DataLoader(urlSession: URLSession.shared)
    func provideDataLoader() -> DataLoading {
        dataLoader
    }
    
    private let cache = Cache(fileManager: FileManager.default)
    func provideCache() -> Caching {
        cache
    }
    
    private lazy var pageFactory = PageFactoryImplementation(
        coinListLoader: CoinListLoader(dataLoader: dataLoader, cache: cache)
    )
    func providePageFactory() -> PageFactory {
        pageFactory
    }
}
