import Combine
import SwiftUI

import PageLoader

final class CoinDetailPage: Page {
    private let viewModel: CoinDetailViewModel
    
    init(viewModel: CoinDetailViewModel) {
        self.viewModel = viewModel
    }
    
    var view: AnyView {
        CoinDetailView(viewModel: viewModel)
            .eraseToAnyView()
    }
    
    var title: String {
        viewModel.title
    }
    
    var loadingStatePublisher: AnyPublisher<PageLoaderState, Never> {
        viewModel.pageStatePublisher
            .eraseToAnyPublisher()
    }
    
    var titleDisplayMode: ToolbarTitleDisplayMode {
        .automatic
    }
    
    func load() {
        viewModel.loadTimeline()
    }
    
    
}
