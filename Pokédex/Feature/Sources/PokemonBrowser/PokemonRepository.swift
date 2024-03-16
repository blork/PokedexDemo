import Foundation
import PokeAPI

public protocol PokemonRepository {
    typealias Page = ResourceURL<ResourceList<PokeAPI.Pokemon>>

    func pokemon(page: Page?) async throws -> (pokemon: [Pokemon], nextPage: Page?)
    
    func additionalInfo(for id: Pokemon.ID) async throws -> Pokemon.AdditionalInfo
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
    
    private enum TaskResult {
        case move(Move)
        case ability(Ability)
    }
    
    public func additionalInfo(for id: Pokemon.ID) async throws -> Pokemon.AdditionalInfo {
        let response = try await client.get(resourceURL: Endpoint.pokemon(id: id))

        return try await withThrowingTaskGroup(of: TaskResult.self, returning: Pokemon.AdditionalInfo.self) { taskGroup in
            for move in response.moves {
                taskGroup.addTask {
                    try .move(await self.client.get(resource: move.move))
                }
            }
            
            for ability in response.abilities {
                taskGroup.addTask {
                    try .ability(await self.client.get(resource: ability.ability))
                }
            }
            
            var abilities: [Ability] = []
            var moves: [Move] = []

            for try await result in taskGroup {
                switch result {
                case let .move(move):
                    moves.append(move)
                case let .ability(ability):
                    abilities.append(ability)
                }
            }
            return Pokemon.AdditionalInfo(abilities, moves)
        }
    }
}

public class StubPokemonRepository: PokemonRepository {
    var error: Error?
    var pokemon: [Pokemon]?
    var info: Pokemon.AdditionalInfo?
    
    public init(error: Error? = nil, pokemon: [Pokemon]? = nil, info: Pokemon.AdditionalInfo? = nil) {
        #if DEBUG
            self.error = error
            self.pokemon = pokemon
            self.info = info
        #else
            fatalError("StubPokemonRepository should not be used in RELEASE mode!")
        #endif
    }
    
    public func pokemon(page _: Page?) async throws -> (pokemon: [Pokemon], nextPage: Page?) {
        if let error { throw error }
        if let pokemon { return (pokemon, nil) }
        throw StubPokemonRepository.notSetUp
    }
    
    public func additionalInfo(for _: Pokemon.ID) async throws -> Pokemon.AdditionalInfo {
        if let error { throw error }
        if let info { return info }
        throw StubPokemonRepository.notSetUp
    }

    public enum StubPokemonRepository: Error {
        case notSetUp
    }
}
