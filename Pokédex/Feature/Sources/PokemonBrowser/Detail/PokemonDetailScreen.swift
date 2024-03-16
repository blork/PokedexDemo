import Base
import SwiftUI

struct PokemonDetailScreen: View {
    
    var viewModel: PokemonDetailViewModel
    
    var body: some View {
        List {
            Section {
                AsyncImage(
                    url: viewModel.pokemon.spriteURL(for: .officialArtwork)
                ) { phase in
                    switch phase {
                    case let .success(image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(.rect(cornerRadius: .cornerRadius(.regular)))
                    default:
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
                .frame(maxWidth: .infinity)
                .aspectRatio(1, contentMode: .fill)

                HStack(alignment: .center) {
                    SpriteView(url: viewModel.pokemon.spriteURL(for: .front))
                    SpriteView(url: viewModel.pokemon.spriteURL(for: .back))
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .listRowSeparator(.hidden)

            Section("Details") {
                Group {
                    LabeledContent("National Dex Number", value: String(format: "#%04d", viewModel.pokemon.id))
                    LabeledContent("Name", value: viewModel.pokemon.name.capitalized)
                    LabeledContent("Height", value: viewModel.pokemon.height.formatted())
                    LabeledContent("Weight", value: viewModel.pokemon.weight.formatted())
                    LabeledContent("Base Experience", value: viewModel.pokemon.baseExperience.formatted())
                }
                .font(.body.monospacedDigit())
            }
    
            switch viewModel.additionalInfo {
            case let .loaded(additionalInfo):
                Section {
                    DisclosureGroup("Abilities") {
                        ForEach(additionalInfo.abilities, id: \.self) { move in
                            VStack(alignment: .leading) {
                                Text(move.name)
                                    .font(.headline)
                                Text(move.description)
                                    .font(.caption)
                            }
                        }
                    }
                }

                Section {
                    DisclosureGroup("Moves") {
                        ForEach(additionalInfo.moves, id: \.self) { move in
                            VStack(alignment: .leading) {
                                Text(move.name)
                                    .font(.headline)
                                LabeledContent("PP", value: move.pp.formatted())
                                    .font(.caption.monospacedDigit())
                                LabeledContent("Accuracy", value: move.accuracy?.formatted(.percent) ?? "N/A")
                                    .font(.caption.monospacedDigit())
                            }
                        }
                    }
                }
            case .loading:
                ProgressView()
                    .frame(maxWidth: .infinity)
            case let .error(error):
                ContentUnavailableView(error.localizedDescription, systemImage: "exclamationmark.triangle")
            }
        }
        .task {
            await viewModel.load()
        }
        #if os(iOS)
        .listStyle(.insetGrouped)
        #endif
    }
}

#Preview("Loaded") {
    NavigationStack {
        PokemonDetailScreen(
            viewModel: .Preview(
                pokemon: .preview(),
                additionalInfo: .loaded(.preview)
            )
        )
    }
}

#Preview("Loading") {
    NavigationStack {
        PokemonDetailScreen(
            viewModel: .Preview(
                pokemon: .preview(),
                additionalInfo: .loading
            )
        )
    }
}

#Preview("Error") {
    NavigationStack {
        PokemonDetailScreen(
            viewModel: .Preview(
                pokemon: .preview(),
                additionalInfo: .error(PreviewError.whoops)
            )
        )
    }
}
