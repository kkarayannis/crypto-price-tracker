import Foundation

import PageLoader

enum PageType: Hashable {
    case coinList
    case coinDetails(coinName: String)
    case settings
}

/// Responsible for creating pages.
protocol PageFactory {
    func createPage(for type: PageType) -> any Page
}

final class PageFactoryImplementation: PageFactory {
    private let coinListLoader: CoinListLoading
    private let coinTimelineLoader: CoinTimelineLoading
    private let settings: Settings
    private let exchangeRates: ExchangeRates
    
    init(
        coinListLoader: CoinListLoading,
        coinTimelineLoader: CoinTimelineLoading,
        settings: Settings,
        exchangeRates: ExchangeRates
    ) {
        self.coinListLoader = coinListLoader
        self.coinTimelineLoader = coinTimelineLoader
        self.settings = settings
        self.exchangeRates = exchangeRates
    }
    
    func createPage(for type: PageType) -> any Page {
        switch type {
        case .coinList:
            createCoinListPage()
        case .coinDetails(let coinName):
            createCoinDetailsPage(for: coinName)
        case .settings:
            createSettingsPage()
        }
    }
    
    private func createCoinListPage() -> any Page {
        let viewModel = CoinListViewModel(
            coinListLoader: coinListLoader,
            settings: settings,
            exchangeRates: exchangeRates,
            pageFactory: self
        )
        return CoinListPage(viewModel: viewModel)
    }
    
    private func createCoinDetailsPage(for coinName: String) -> any Page {
        let viewModel = CoinDetailViewModel(
            coinTimelineLoader: coinTimelineLoader,
            settings: settings, exchangeRates: exchangeRates,
            coinName: coinName
        )
        return CoinDetailPage(viewModel: viewModel)
    }
    
    private func createSettingsPage() -> any Page {
        return SettingsPage(settings: settings)
    }
}
