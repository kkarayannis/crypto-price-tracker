@testable import Crypto_Price_Tracker

import Combine
import Foundation
import SwiftUI

import PageLoader

final class PageFactoryFake: PageFactory {
    func createPage(for type: PageType) -> Page {
        PageFake()
    }
}

private final class PageFake: Page {
    var view: AnyView {
        EmptyView()
            .eraseToAnyView()
    }
    
    var title: String {
        ""
    }
    
    var loadingStatePublisher: AnyPublisher<PageLoaderState, Never> {
        Just(.loaded)
            .eraseToAnyPublisher()
    }
    
    var titleDisplayMode: ToolbarTitleDisplayMode {
        .automatic
    }
    
    func load() {}
    
}


