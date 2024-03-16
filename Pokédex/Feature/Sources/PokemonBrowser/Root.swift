import SwiftUI

public struct Root: View {
    
    @State private var path: NavigationPath = .init()
    
    private let pokemonRepository: PokemonRepository
    
    public init(pokemonRepository: PokemonRepository) {
        self.pokemonRepository = pokemonRepository
    }

    public var body: some View {
        NavigationStack(path: $path) {
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
                    .navigationBarTitleDisplayMode(.inline)
                }
        }
    }
}

#Preview {
    Root(pokemonRepository: StubPokemonRepository(pokemon: [.preview()]))
}
