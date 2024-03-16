import PokeAPI
import PokemonBrowser
import SwiftUI

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
        #if os(macOS)
        .windowToolbarStyle(.expanded)
        .windowResizability(.contentSize)
        #endif
    }
}
