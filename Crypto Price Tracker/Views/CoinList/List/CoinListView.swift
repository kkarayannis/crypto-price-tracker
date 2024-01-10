import Combine
import SwiftUI

import PageLoader

/// View that displays a list of cryptocurrencies.
struct CoinListView: View {
    @State private var items = [CoinListItemViewModel]()
    @State private var isPresentingSettings = false
    private let viewModel: CoinListViewModel
    
    init(viewModel: CoinListViewModel) {
        self.viewModel = viewModel
    }
        
    var body: some View {
        List(items) { item in
            NavigationLink(value: PageType.coinDetails(item.name)) {
                CoinListItemView(viewModel: item)
            }
        }
        .onReceive(viewModel.itemsPublisher) {
            items = $0
        }
        .refreshable {
            viewModel.loadItems()
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

//#Preview {
//    let viewModel = CoinListViewModel(coinListLoader: CoinListLoader.fake, imageLoader: ImageLoader.fake)
//    viewModel.__setItems([CoinListItemViewModel.example])
//    
//    return CoinListView(viewModel: viewModel)
//}
