import Charts
import SwiftUI

struct CoinDetailView: View {
    private let viewModel: CoinDetailViewModel
    @State private var prices = [CoinPrice]()
    
    init(viewModel: CoinDetailViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Chart {
            ForEach(prices) { price in
                LineMark(
                    // TODO: localize
                    x: .value("Time", Date(timeIntervalSince1970: price.timestamp)),
                    y: .value("Price", price.value)
                )
            }
        }
        .onReceive(viewModel.priceTimelinePublisher) {
            prices = $0
        }
        .refreshable {
            viewModel.loadTimeline()
        }
    }
}
