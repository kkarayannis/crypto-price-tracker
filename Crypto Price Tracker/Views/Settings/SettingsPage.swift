import Combine
import SwiftUI

import PageLoader

final class SettingsPage: Page {
    private let settings: Settings
    
    init(settings: Settings) {
        self.settings = settings
    }
    
    var view: AnyView {
        SettingsView(settings: settings)
            .eraseToAnyView()
    }
    
    // TODO: Localize
    var title: String {
        "Settings"
    }
    
    var loadingStatePublisher: AnyPublisher<PageLoaderState, Never> {
        Just(.loaded)
            .eraseToAnyPublisher()
    }
    
    var titleDisplayMode: ToolbarTitleDisplayMode {
        .automatic
    }
    
    func load() {
        // no-op
    }
    
    
}
