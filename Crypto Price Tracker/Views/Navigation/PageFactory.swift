import Foundation

import PageLoader

enum PageType: Hashable {
    case coinList
    case coinDetails
    case settings
}

/// Responsible for creating pages.
protocol PageFactory {
    func createPage(for type: PageType) -> any Page
}

final class PageFactoryImplementation: PageFactory {
    private let coinListLoader: CoinListLoading
    
    init(coinListLoader: CoinListLoading) {
        self.coinListLoader = coinListLoader
    }
    
    func createPage(for type: PageType) -> any Page {
//        switch type {
//        case .coinList:
            createCoinListPage()
//        case .coinDetails:
//            break
//        case .settings:
//            break
//        }
    }
    
    private func createCoinListPage() -> any Page {
        let viewModel = CoinListViewModel(coinListLoader: coinListLoader)
        return CoinListPage(viewModel: viewModel)
    }
    
//    private func createCoinDetailsPage() -> any Page {
//        
//    }
//    
//    private func createSettingsPage() -> any Page {
//        
//    }
}
