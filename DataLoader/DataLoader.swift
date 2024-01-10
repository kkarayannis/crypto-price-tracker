import Foundation
import Combine

public enum DataLoaderMethod: String {
    case get = "GET"
}

/// Loads data from the network.
public protocol DataLoading {
    func loadData(for url: URL, parameters: [String: Any]?, method: DataLoaderMethod) -> AnyPublisher<Data, URLError>
}

public extension DataLoading {
    func dataLoadingPublisher(for url: URL) -> AnyPublisher<Data, URLError> {
        loadData(for: url, parameters: nil, method: .get)
    }
}

public final class DataLoader: DataLoading {
    private let urlSession: URLSession
    
    public init(urlSession: URLSession) {
        self.urlSession = urlSession
    }
    
    public func loadData(
        for url: URL,
        parameters: [String: Any]?,
        method: DataLoaderMethod
    ) -> AnyPublisher<Data, URLError> {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let parameters {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        }
        
        return urlSession.dataTaskPublisher(for: request)
            .map { data, _ in
                return data
            }
            .eraseToAnyPublisher()
    }
}
