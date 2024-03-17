import Base
import PokeAPI
@testable import PokemonBrowser
import XCTest

final class PokemonRepositoryTests: XCTestCase {
    
    func test_apiReturnsNoPokemon_noPokemonAreReturned() async throws {
        let client = StubClient(
            responses: [
                ResourceList<PokeAPI.Pokemon>(
                    count: 0,
                    next: nil,
                    previous: nil,
                    results: []
                ),
            ]
        )
        let repo = RemotePokemonRepository(client: client)
        
        let pokemon = try await repo.pokemon(page: nil)
        
        XCTAssertEqual(pokemon.pokemon.count, 0)
    }
    
    func test_apiThrowsError_errorIsPropagated() async throws {
        let client = StubClient(error: PreviewError.whoops)
        let repo = RemotePokemonRepository(client: client)
        
        do {
            let _ = try await repo.pokemon(page: nil)
            XCTFail()
        } catch {
            XCTAssert(error is PreviewError)
        }
    }

    func test_apiReturnsOnePokemon_onePokemonIsReturned() async throws {
        let client = StubClient(
            responses: [
                ResourceList<PokeAPI.Pokemon>(
                    count: 1,
                    next: nil,
                    previous: nil,
                    results: [
                        .init(
                            name: "Pokemon 1",
                            url: .init(url: URL(string: "http://example.com")!)
                        ),
                    ]
                ),
                PokeAPI.Pokemon(
                    id: 1,
                    name: "Pokemon 2",
                    baseExperience: 2,
                    height: 3,
                    weight: 4,
                    abilities: [],
                    moves: [],
                    species: .init(
                        name: "Pokemon 2",
                        url: .init(url: URL(string: "http://example.com")!)
                    )
                ),
            ]
        )
        let repo = RemotePokemonRepository(client: client)
        
        let response = try await repo.pokemon(page: nil)
        
        XCTAssertEqual(response.pokemon.count, 1)
        let pokemon = response.pokemon.first!
        XCTAssertEqual(pokemon.id, 1)
        XCTAssertEqual(pokemon.name, "Pokemon 2")
        XCTAssertEqual(pokemon.baseExperience, 2)
        XCTAssertEqual(pokemon.height, .init(value: 3, unit: .decimeters))
        XCTAssertEqual(pokemon.weight, .init(value: 400, unit: .grams))
    }
}
