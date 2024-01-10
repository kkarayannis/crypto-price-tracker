import Foundation

import Cache
import DataLoader

/// An object that instantiates and holds references to long-living objects.
protocol ServiceProviding {
    func provideDataLoader() -> DataLoading
    func providePageFactory() -> PageFactory
    func provideCache() -> Caching
    func provideSettings() -> Settings
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
    
    private let settings = Settings(userDefaults: UserDefaults.standard)
    func provideSettings() -> Settings {
        settings
    }
    
    private lazy var pageFactory = PageFactoryImplementation(
        coinListLoader: CoinListLoader(dataLoader: dataLoader, cache: cache), settings: settings
    )
    func providePageFactory() -> PageFactory {
        pageFactory
    }
}
