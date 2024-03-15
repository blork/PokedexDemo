import Base
@testable import PokemonBrowser
import XCTest

final class PokemonListViewModelTests: XCTestCase {
    
    func test_initialValueIsLoading() async throws {
        let repo = StubPokemonRepository()
        let vm = PokemonListViewModel(pokemonRepository: repo)
                
        XCTAssertTrue(vm.pokemon.isLoading)
    }
    
    func test_repoThrowsError_load_pokemonContainsError() async throws {
        let repo = StubPokemonRepository(error: PreviewError.whoops)
        let vm = PokemonListViewModel(pokemonRepository: repo)
        
        await vm.load()
        
        XCTAssertTrue(vm.pokemon.isError)
    }
    
    func test_noPokemonReturned_load_pokemonIsLoadedAndEmpty() async throws {
        let repo = StubPokemonRepository(pokemon: [])
        let vm = PokemonListViewModel(pokemonRepository: repo)

        guard case .firstLoad = vm.nextPage else {
            return XCTFail()
        }
        
        await vm.load()
        
        XCTAssertTrue(vm.pokemon.isLoaded)
        XCTAssertTrue(vm.pokemon.value!.isEmpty)
        guard case .end = vm.nextPage else {
            return XCTFail()
        }
    }
    
    func test_pokemonReturned_load_photosIsLoadedAndContainsCorrectPokemon() async throws {
        let repo = StubPokemonRepository(pokemon: [
            .preview(id: 1),
            .preview(id: 2)
        ])
        let vm = PokemonListViewModel(pokemonRepository: repo)
        
        await vm.load()

        XCTAssertTrue(vm.pokemon.isLoaded)
        let pokemon = vm.pokemon.value!
        XCTAssertEqual(pokemon.count, 2)
        
        XCTAssertTrue(pokemon.contains { $0.id == 1 })
        XCTAssertTrue(pokemon.contains { $0.id == 2 })
    }
}
