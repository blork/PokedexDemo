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
            #if os(macOS)
                .frame(
                    minWidth: 390,
                    idealWidth: 400,
                    maxWidth: 600,
                    minHeight: 300,
                    idealHeight: 900,
                    maxHeight: .infinity
                )
            #endif
        }
        #if os(macOS)
        .windowToolbarStyle(.expanded)
        .windowResizability(.contentSize)
        #endif
    }
}
