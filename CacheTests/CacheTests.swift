import XCTest
@testable import Cache

final class CacheTests: XCTestCase {

    // Unit under test
    private var cache: Caching!
    
    // Dependencies
    private var fileManagerFake: FileManagerFake!
    
    override func setUp() {
        super.setUp()
        fileManagerFake = FileManagerFake()
        cache = Cache(fileManager: fileManagerFake)
    }

    func testCacheWritesDataToDisk() async throws {
        // Given some data
        let data = "key to my kingdom".data(using: .utf8)!
        
        // When that data is stored in the cache
        let key = "super-secret-key"
        try await cache.store(data: data, key: key)
        
        // Then the data is stored
        XCTAssertEqual(fileManagerFake.dataStored, data)
        XCTAssertTrue(fileManagerFake.pathStored?.hasSuffix(key) ?? false)
    }
    
    func testCacheReadsDataFromDisk() async throws {
        // Given some data on the disk
        let data = "key to my kingdom".data(using: .utf8)!
        fileManagerFake.dataToReturn = data
        
        // When the cache reads the data
        let key = "super-secret-key"
        let dataFetched = try await cache.data(for: key)
        
        // Then the data fetched is correct
        XCTAssertEqual(dataFetched, data)
        
        // and the path that was used is correct
        XCTAssertTrue(fileManagerFake.pathToRead?.hasSuffix(key) ?? false)
    }
    
    func testCacheThrowsExceptionWhenWritingError() async throws {
        // Given some data
        let data = "key to my kingdom".data(using: .utf8)!
        
        // and the file manager will refuse to store the data
        fileManagerFake.boolToReturn = false
        
        // When that data is stored in the cache
        let key = "super-secret-key"
        do {
            try await cache.store(data: data, key: key)
        } catch {
            // Then an exception is thrown.
            XCTAssertEqual(error as? CacheError, .cannotStoreData)
            return
        }
        
        XCTFail("Should not reach here")
    }

}
