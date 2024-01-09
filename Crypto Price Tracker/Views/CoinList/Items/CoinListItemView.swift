import SwiftUI

/// View that displays an item in the coin list.
struct CoinListItemView: View {
    private let viewModel: CoinListItemViewModel
    
    init(viewModel: CoinListItemViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        HStack(alignment: .top) {
            HStack {
                Text(viewModel.name)
                    .font(.headline)
                Spacer()
                Text(viewModel.price)
                    .font(.subheadline)
            }
            Spacer()
        }
    }
}

//#Preview {
//    return CoinListItemView(viewModel: CoinListItemViewModel.example)
//}
