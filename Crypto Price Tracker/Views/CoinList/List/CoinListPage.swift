import Combine
import SwiftUI

import PageLoader

final class CoinListPage: Page {
    private let viewModel: CoinListViewModel
    
    init(viewModel: CoinListViewModel) {
        self.viewModel = viewModel
    }
    
    var view: AnyView {
        CoinListView(viewModel: viewModel)
            .eraseToAnyView()
    }
    
    var title: String {
        viewModel.title
    }
    
    var loadingStatePublisher: AnyPublisher<PageLoaderState, Never> {
        viewModel.pageStatePublisher
    }
    
    var titleDisplayMode: ToolbarTitleDisplayMode {
        .large
    }
    
    func load() {
        viewModel.loadItems()
    }
}
