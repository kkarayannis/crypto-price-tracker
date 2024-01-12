import Foundation

final class FileManagerFake: FileManager {
    
    var dataStored: Data?
    var pathStored: String?
    var boolToReturn = true
    override func createFile(
        atPath path: String,
        contents data: Data?,
        attributes attr: [FileAttributeKey : Any]? = nil
    ) -> Bool {
        pathStored = path
        dataStored = data
        return boolToReturn
    }
    
    var dataToReturn: Data?
    var pathToRead: String?
    override func contents(atPath path: String) -> Data? {
        pathToRead = path
        return dataToReturn
    }
}
