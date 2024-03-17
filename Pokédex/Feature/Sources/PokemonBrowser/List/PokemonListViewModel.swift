import Base
import Foundation
import PokeAPI

@Observable public class PokemonListViewModel {
    
    enum PageState {
        case firstLoad
        case subsequentLoad(PokemonRepository.Page)
        case end
        
        var page: PokemonRepository.Page? {
            switch self {
            case .firstLoad, .end:
                return nil
            case let .subsequentLoad(page):
                return page
            }
        }
    }
    
    let pokemonRepository: PokemonRepository
    
    var nextPage: PageState = .firstLoad
    
    var pokemon: ResourceState<[Pokemon]> = .loading
    
    var filteredPokemon: [Pokemon]? {
        if search.isEmpty {
            pokemon.value
        } else {
            pokemon.value?.filter { $0.name.localizedCaseInsensitiveContains(search) }
        }
    }

    var search = ""
    var isSearching = false
    
    public init(pokemonRepository: PokemonRepository) {
        self.pokemonRepository = pokemonRepository
    }
    
    func load() async {
        if case .end = nextPage { return }
        do {
            let (monsters, nextPage) = try await pokemonRepository.pokemon(page: nextPage.page)
            pokemon = .loaded((pokemon.value ?? []) + monsters)
            if let nextPage {
                self.nextPage = .subsequentLoad(nextPage)
            } else {
                self.nextPage = .end
            }
            
            if isSearching {
                await load()
            }
        } catch ClientError.cancellation {
            // Do nothing
        } catch {
            print(error)
            pokemon = .error(error)
        }
    }
}

extension PokemonListViewModel {
    class Preview: PokemonListViewModel {
        init(_ state: ResourceState<[Pokemon]>) {
            super.init(pokemonRepository: StubPokemonRepository())
            pokemon = state
        }

        override func load() async {}
    }
}
