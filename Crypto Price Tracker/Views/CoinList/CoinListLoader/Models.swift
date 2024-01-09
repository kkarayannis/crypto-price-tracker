import Foundation

/// The objects that are received from the endpoint.

struct Coin: Codable {
    let symbol: String
    let baseAsset: String
    let quoteAsset: String
    let openPrice: String
    let lowPrice: String
    let highPrice: String
    let lastPrice: String
    let volume: String
    let bidPrice: String
    let askPrice: String
    let at: Int64
}
