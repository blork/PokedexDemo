import Foundation

public struct Resource<T: Decodable>: Decodable {
    public let name: String
    public let url: ResourceURL<T>
    
    public init(name: String, url: ResourceURL<T>) {
        self.name = name
        self.url = url
    }
}

public struct ResourceList<T: Decodable>: Decodable {
    public let count: Int
    public let next: ResourceURL<Self>?
    public let previous: ResourceURL<Self>?
    public let results: [Resource<T>]
    
    public init(count: Int, next: ResourceURL<Self>?, previous: ResourceURL<Self>?, results: [Resource<T>]) {
        self.count = count
        self.next = next
        self.previous = previous
        self.results = results
    }
}

public struct ResourceURL<T: Decodable>: Decodable {
    public let rawValue: URL

    public init(url: URL) {
        self.rawValue = url
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        rawValue = try container.decode(URL.self)
    }
}
