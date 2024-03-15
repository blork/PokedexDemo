import Foundation
import OSLog

public enum Endpoint {
    public static var pokemon = ResourceURL<ResourceList<Pokemon>>(url: URL(string: "https://pokeapi.co/api/v2/pokemon/")!)
}

public protocol Client {
    func get<T>(resource: Resource<T>) async throws -> T
    
    func get<T>(resourceURL: ResourceURL<T>) async throws -> T
}

public enum HTTPMethod: String {
    case GET
    case POST
}

enum ClientError: Error {
    case invalidURL
    case unexpected(response: HTTPURLResponse)
    case unknown(underlying: Error)
}

extension PokeAPIClient: Client {
    public func get<T>(resource: Resource<T>) async throws -> T {
        return try await get(resourceURL: resource.url)
    }
    
    public func get<T>(resourceURL: ResourceURL<T>) async throws -> T {
        return try await perform(URLRequest(url: resourceURL.rawValue))
    }
}

public class PokeAPIClient {
    
    private static let baseURL = "https://pokeapi.co/api/v2/"
    
    let session: Session
    
    let decoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    public init(session: Session) {
        self.session = session
    }
    
    func request(_ method: HTTPMethod, path: String, queryItems: [URLQueryItem] = []) throws -> URLRequest {
        var components = URLComponents(string: PokeAPIClient.baseURL)!
        components.queryItems = queryItems
        components.path += path
        
        if let url = components.url {
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            return request
        } else {
            throw ClientError.invalidURL
        }
    }
    
    func perform<T>(_ request: URLRequest) async throws -> T where T: Decodable {
        let data: Data
        let urlResponse: URLResponse
        
        Logger.default.debug("🔼 \(request.httpMethod!) \(request.url!.absoluteString, align: .left(columns: 1))")
        if let body = request.httpBody, let string = String(data: body, encoding: .utf8) {
            Logger.default.debug("\t\(string)")
        }
        
        do {
            let response = try await session.data(for: request)
            data = response.0
            urlResponse = response.1
        } catch {
            throw ClientError.unknown(underlying: error)
        }
        
        let httpResponse = (urlResponse as! HTTPURLResponse)
        Logger.default.debug("🔽 \(httpResponse.statusCode) \(request.url!.absoluteString)")
        if let body = String(data: data, encoding: .utf8) {
            Logger.default.debug("\(body)")
        }
        
        if httpResponse.statusCode != 200 {
            Logger.default.error("Unexpected status code: \(httpResponse.statusCode)")
            throw ClientError.unexpected(response: httpResponse)
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            Logger.default.error("Unexpected error: \(String(describing: error))")
            throw ClientError.unknown(underlying: error)
        }
    }
}
