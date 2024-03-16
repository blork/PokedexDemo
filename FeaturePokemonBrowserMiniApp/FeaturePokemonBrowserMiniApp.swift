import PokemonBrowser
import SwiftUI

@main
struct FeaturePokemonBrowserMiniApp: App {
    var body: some Scene {
        WindowGroup {
            PokemonBrowser.Root(pokemonRepository: StubPokemonRepository(pokemon: .preview, info: .preview))
        }
    }
}
