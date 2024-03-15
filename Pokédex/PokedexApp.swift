import SwiftUI
import PokemonBrowser
import PokeAPI

@main
struct PokedexApp: App {
    
    let client: Client
    
    let pokemonRepository: PokemonRepository

    init() {
        client = PokeAPIClient(session: URLSession.shared)
        pokemonRepository = RemotePokemonRepository(client: client)
    }

    var body: some Scene {
        WindowGroup {
            PokemonBrowser.Root(pokemonRepository: pokemonRepository)
        }
    }
}
