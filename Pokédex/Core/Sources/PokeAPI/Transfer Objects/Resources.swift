import Foundation

public struct Resource<T: Decodable>: Decodable {
    public let name: String
    public let url: ResourceURL<T>
}

public struct ResourceList<T: Decodable>: Decodable {
    public let count: Int
    public let next: ResourceURL<Self>?
    public let previous: ResourceURL<Self>?
    public let results: [Resource<T>]
}

public struct ResourceURL<T: Decodable>: Decodable {
    public let rawValue: URL

    init(url: URL) {
        self.rawValue = url
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        rawValue = try container.decode(URL.self)
    }
}
