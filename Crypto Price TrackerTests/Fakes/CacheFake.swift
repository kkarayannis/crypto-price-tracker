import Cache

final class CacheFake: Caching {
    var dataStored: Data?
    func store(data: Data, key: String) async throws {
        dataStored = data
    }
    
    var dataToReturn: Data?
    func data(for key: String) async throws -> Data? {
        dataToReturn
    }
}
