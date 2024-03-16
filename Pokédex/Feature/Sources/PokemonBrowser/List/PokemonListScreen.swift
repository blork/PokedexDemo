import Base
import PokeDesign
import SwiftUI

struct PokemonListScreen: View {
    
    var viewModel: PokemonListViewModel
    
    init(viewModel: PokemonListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        @Bindable var viewModel = viewModel
        List {
            Section {
                ForEach(viewModel.filteredPokemon ?? placeholders) { monster in
                    NavigationLink(value: monster) {
                        PokemonRow(pokemon: monster)
                    }
                }
            }
            
            Section {
                ProgressView()
                    .progressViewStyle(.circular)
                    .task {
                        await viewModel.load()
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .listRowSeparator(.hidden)
            }
            .listSectionSeparator(.hidden)
        }
        .listStyle(.plain)
        .loading(resource: viewModel.pokemon)
        .searchable(text: $viewModel.search)
        .task {
            await viewModel.load()
        }
    }
    
    private var placeholders: [Pokemon] {
        (0 ..< 20).map { .preview(id: $0) }
    }
}

#Preview("Loaded") {
    NavigationStack {
        PokemonListScreen(viewModel: .Preview(.loaded(.preview)))
    }
}

#Preview("Loading") {
    NavigationStack {
        PokemonListScreen(viewModel: .Preview(.loading))
    }
}

#Preview("Error") {
    NavigationStack {
        PokemonListScreen(viewModel: .Preview(.error(PreviewError.whoops)))
    }
}
