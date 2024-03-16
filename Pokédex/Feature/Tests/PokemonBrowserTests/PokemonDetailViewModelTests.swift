import Base
@testable import PokemonBrowser
import XCTest

final class PokemonDetailViewModelTests: XCTestCase {
    
    func test_initialValueIsLoading() async throws {
        let repo = StubPokemonRepository()
        let pokemon = Pokemon.preview()
        let vm = PokemonDetailViewModel(pokemon: pokemon, pokemonRepository: repo)
                
        XCTAssertTrue(vm.additionalInfo.isLoading)
    }
    
    func test_repoThrowsError_load_infoContainsError() async throws {
        let repo = StubPokemonRepository(error: PreviewError.whoops)
        let pokemon = Pokemon.preview()
        let vm = PokemonDetailViewModel(pokemon: pokemon, pokemonRepository: repo)

        await vm.load()
        
        XCTAssertTrue(vm.additionalInfo.isError)
    }
    
    func test_noInfoReturned_load_infoIsLoadedAndEmpty() async throws {
        let repo = StubPokemonRepository(info: .init(abilities: [], moves: []))
        let pokemon = Pokemon.preview()
        let vm = PokemonDetailViewModel(pokemon: pokemon, pokemonRepository: repo)

        await vm.load()
        
        XCTAssertTrue(vm.additionalInfo.isLoaded)
        XCTAssertTrue(vm.additionalInfo.value?.moves.isEmpty == true)
        XCTAssertTrue(vm.additionalInfo.value?.abilities.isEmpty == true)
    }
    
    func test_infoReturned_load_infoIsLoadedAndContainsCorrectAbilitiesAndMoves() async throws {
        let repo = StubPokemonRepository(info: .init(abilities: [
            .init(name: "Example Ability", description: "Test"),
        ], moves: [
            .init(name: "Example Move", accuracy: 1, pp: 2),
        ]))
        
        let pokemon = Pokemon.preview()
        let vm = PokemonDetailViewModel(pokemon: pokemon, pokemonRepository: repo)

        await vm.load()

        XCTAssertTrue(vm.additionalInfo.isLoaded)
        let info = vm.additionalInfo.value!
        XCTAssertEqual(info.moves.count, 1)
        XCTAssertEqual(info.abilities.count, 1)

        let ability = info.abilities.first!
        XCTAssertEqual(ability.name, "Example Ability")
        XCTAssertEqual(ability.description, "Test")

        let move = info.moves.first!
        XCTAssertEqual(move.name, "Example Move")
        XCTAssertEqual(move.accuracy, 1)
        XCTAssertEqual(move.pp, 2)
    }
}
