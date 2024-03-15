import Base
import PokeDesign
import SwiftUI

struct PokemonListScreen: View {
    
    var viewModel: PokemonListViewModel
    
    init(viewModel: PokemonListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        List {
            Section {
                ForEach(viewModel.pokemon.value ?? placeholders) { monster in
                    NavigationLink(value: monster) {
                        HStack {
                            Text(String(monster.id))
                            Text(monster.name)
                        }
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
