import SwiftUI

struct PokemonListScreen: View {
    
    var viewModel: PokemonListViewModel
    
    init(viewModel: PokemonListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Group {
            if let monsters = viewModel.pokemon.value {
                List {
                    ForEach(monsters) { monster in
                        NavigationLink(value: monster) {
                            HStack {
                                Text(String(monster.id))
                                Text(monster.name)
                            }
                        }
                    }
                    ProgressView("Loading next page")
                        .task {
                            await viewModel.load()
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .animation(.default, value: monsters)
            } else {
                ContentUnavailableView("No Pokemon", systemImage: "circle")
            }
        }
        .task {
            await viewModel.load()
        }
    }
}

#Preview {
    NavigationStack {
        PokemonListScreen(viewModel: .Preview(.loaded([.preview])))
    }
}
