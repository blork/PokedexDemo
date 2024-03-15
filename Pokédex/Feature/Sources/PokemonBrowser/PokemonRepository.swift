import Foundation
import PokeAPI

public protocol PokemonRepository {
    typealias Page = ResourceURL<ResourceList<PokeAPI.Pokemon>>

    func pokemon(page: Page?) async throws -> (pokemon: [Pokemon], nextPage: Page?)
}

public class RemotePokemonRepository: PokemonRepository {
    let client: Client
    
    public init(client: Client) {
        self.client = client
    }
    
    public func pokemon(page: Page?) async throws -> (pokemon: [Pokemon], nextPage: Page?) {
        let currentPage = page ?? Endpoint.pokemon
        
        let response = try await client.get(resourceURL: currentPage)
        
        let pokemon = try await withThrowingTaskGroup(of: PokeAPI.Pokemon.self, returning: [Pokemon].self) { taskGroup in
            for result in response.results {
                taskGroup.addTask {
                    try await self.client.get(resource: result)
                }
            }
            
            return try await taskGroup.reduce(into: [Pokemon]()) { partialResult, detail in
                partialResult.append(.init(detail))
            }
        }.sorted { lhs, rhs in
            lhs.id < rhs.id
        }
        
        return (pokemon, response.next)
    }
}

public class StubPokemonRepository: PokemonRepository {
    var error: Error?
    var pokemon: [Pokemon]?
        
    public init(error: Error? = nil, pokemon: [Pokemon]? = nil) {
        #if DEBUG
            self.error = error
            self.pokemon = pokemon
        #else
            fatalError("StubPokemonRepository should not be used in RELEASE mode!")
        #endif
    }
    
    public func pokemon(page _: Page?) async throws -> (pokemon: [Pokemon], nextPage: Page?) {
        if let error { throw error }
        if let pokemon { return (pokemon, nil) }
        throw StubPokemonRepository.notSetUp
    }

    public enum StubPokemonRepository: Error {
        case notSetUp
    }
}
