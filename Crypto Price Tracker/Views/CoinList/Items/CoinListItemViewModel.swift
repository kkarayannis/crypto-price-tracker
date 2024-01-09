import Foundation

final class CoinListItemViewModel: Identifiable, Equatable {
    let name: String
    let price: String
    
    init(name: String, price: String) {
        self.name = name
        self.price = price
    }
    
    static func == (lhs: CoinListItemViewModel, rhs: CoinListItemViewModel) -> Bool {
        lhs.name == rhs.name &&
        lhs.price == rhs.price
    }
    
//    #if DEBUG
//    static var example: Self {
//        self.init(
//            title: "Title",
//            id: "id",
//            authors: "Authors",
//            year: "2004",
//            coverViewModel: CoverViewModel.example
//        )
//    }
//    #endif
}
