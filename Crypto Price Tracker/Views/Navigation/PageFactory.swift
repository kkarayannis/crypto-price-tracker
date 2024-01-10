import Foundation

import PageLoader

enum PageType: Hashable {
    case coinList
    case coinDetails(String)
    case settings
}

/// Responsible for creating pages.
protocol PageFactory {
    func createPage(for type: PageType) -> any Page
}

final class PageFactoryImplementation: PageFactory {
    private let coinListLoader: CoinListLoading
    private let settings: Settings
    
    init(coinListLoader: CoinListLoading, settings: Settings) {
        self.coinListLoader = coinListLoader
        self.settings = settings
    }
    
    func createPage(for type: PageType) -> any Page {
        switch type {
        case .coinList:
            createCoinListPage()
        case .coinDetails:
            createCoinListPage()
        case .settings:
            createSettingsPage()
        }
    }
    
    private func createCoinListPage() -> any Page {
        let viewModel = CoinListViewModel(coinListLoader: coinListLoader, settings: settings, pageFactory: self)
        return CoinListPage(viewModel: viewModel)
    }
    
//    private func createCoinDetailsPage() -> any Page {
//        
//    }
//    
    private func createSettingsPage() -> any Page {
        return SettingsPage(settings: settings)
    }
}
