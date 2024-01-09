import SwiftUI

@main
struct Crypto_Price_TrackerApp: App {
    private let serviceProvider = ServiceProvider()
    
    var body: some Scene {
        WindowGroup {
            NavigationCoordinator(rootPageType: .coinList, pageFactory: serviceProvider.providePageFactory())
        }
    }
}
