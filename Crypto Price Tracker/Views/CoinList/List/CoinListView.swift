import Combine
import SwiftUI

import PageLoader

/// View that displays a list of cryptocurrencies.
struct CoinListView: View {
    private let viewModel: CoinListViewModel
    @State private var items = [CoinListItemViewModel]()
    @State private var isPresentingSettings = false
    
    init(viewModel: CoinListViewModel) {
        self.viewModel = viewModel
    }
        
    var body: some View {
        List(items) { item in
            NavigationLink(value: PageType.coinDetails(coinName: item.name)) {
                CoinListItemView(viewModel: item)
            }
        }
        .onReceive(viewModel.itemsPublisher) {
            items = $0
        }
        .refreshable {
            viewModel.loadCoins()
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    isPresentingSettings = true
                }) {
                    Image(systemName: "gear")
                }
            }
        }
        .sheet(isPresented: $isPresentingSettings) {
            ModalPageView(isPresented: $isPresentingSettings, page: viewModel.pageFactory.createPage(for: .settings))
        }
    }
}
