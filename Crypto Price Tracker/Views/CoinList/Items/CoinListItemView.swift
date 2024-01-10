import SwiftUI

/// View that displays an item in the coin list.
struct CoinListItemView: View {
    @ObservedObject private var viewModel: CoinListItemViewModel
    
    init(viewModel: CoinListItemViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        HStack(alignment: .top) {
            HStack {
                Text(viewModel.name)
                    .font(.headline)
                Spacer()
                Text(viewModel.priceInCurrency ?? "")
                    .font(.subheadline)
            }
            Spacer()
        }
    }
}

//#Preview {
//    return CoinListItemView(viewModel: CoinListItemViewModel.example)
//}
