import SwiftUI

public struct Root: View {
    
    @State private var path: NavigationPath = .init()
    
    private let pokemonRepository: PokemonRepository
    
    public init(pokemonRepository: PokemonRepository) {
        self.pokemonRepository = pokemonRepository
    }

    public var body: some View {
        NavigationSplitView {
            PokemonListScreen(viewModel: .init(pokemonRepository: pokemonRepository))
                .navigationTitle("Pokédex")
                .navigationDestination(for: Pokemon.self) { pokemon in
                    PokemonDetailScreen(
                        viewModel: .init(
                            pokemon: pokemon,
                            pokemonRepository: pokemonRepository
                        )
                    )
                    .navigationTitle(pokemon.name.capitalized)
                    #if os(iOS)
                        .navigationBarTitleDisplayMode(.inline)
                    #endif
                    #if os(macOS)
                    .navigationSplitViewColumnWidth(600)
                    #endif
                }
                #if os(macOS)
                .navigationSplitViewColumnWidth(300)
                #endif
        } detail: {
            ContentUnavailableView("Choose a Pokémon", systemImage: "questionmark.app.dashed")
            #if os(iOS)
                .navigationBarTitleDisplayMode(.inline)
            #endif
            #if os(macOS)
            .navigationSplitViewColumnWidth(600)
            #endif
        }
    }
}

#Preview {
    Root(pokemonRepository: StubPokemonRepository(pokemon: [.preview()]))
}
