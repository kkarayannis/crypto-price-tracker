import Combine
import SwiftUI

/// View that displays a list of cryptocurrencies.
struct CoinListView: View {
    @State private var items = [CoinListItemViewModel]()
    private let viewModel: CoinListViewModel
    
    init(viewModel: CoinListViewModel) {
        self.viewModel = viewModel
    }
        
    var body: some View {
        List(items) { item in
//            NavigationLink(value: PageType.bookInfo(id: item.id, title: item.title)) {
                CoinListItemView(viewModel: item)
//            }
        }
        .onReceive(viewModel.itemsPublisher) {
            items = $0
        }
    }
}

//#Preview {
//    let viewModel = CoinListViewModel(coinListLoader: CoinListLoader.fake, imageLoader: ImageLoader.fake)
//    viewModel.__setItems([CoinListItemViewModel.example])
//    
//    return CoinListView(viewModel: viewModel)
//}
