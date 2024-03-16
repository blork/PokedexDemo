import Base
import Foundation
import PokeAPI

@Observable public class PokemonDetailViewModel {
        
    let pokemon: Pokemon
    let pokemonRepository: PokemonRepository
    
    var additionalInfo: ResourceState<Pokemon.AdditionalInfo> = .loading
    
    public init(pokemon: Pokemon, pokemonRepository: PokemonRepository) {
        self.pokemon = pokemon
        self.pokemonRepository = pokemonRepository
    }
    
    func load() async {
        additionalInfo = .loading
        do {
            additionalInfo = .loaded(try await pokemonRepository.additionalInfo(for: pokemon.id))
        } catch {
            additionalInfo = .error(error)
        }
    }
}

extension PokemonDetailViewModel {
    class Preview: PokemonDetailViewModel {
        init(pokemon: Pokemon, additionalInfo: ResourceState<Pokemon.AdditionalInfo>) {
            super.init(pokemon: pokemon, pokemonRepository: StubPokemonRepository())
            self.additionalInfo = additionalInfo
        }

        override func load() async {}
    }
}
