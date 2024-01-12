@testable import Crypto_Price_Tracker

import Foundation

enum TestError: Error {
    case generic
    case dataError
}

final class Helpers {
    static func responseData() throws -> Data {
        let bundle = Bundle(for: Self.self)
        guard let url = bundle.url(forResource: "24hr", withExtension: "json") else {
            throw TestError.dataError
        }
        return try Data(contentsOf: url)
    }
    
    static func responseCoins() throws -> [Coin] {
        let data = try responseData()
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return try decoder.decode([Coin].self, from: data)
    }
}
