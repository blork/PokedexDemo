import SwiftUI
import PokeAPI

struct ContentView: View {
    
    @State var imageURL: URL?
    
    var body: some View {
        VStack {
            AsyncImage(url: imageURL)
        }
        .padding()
        .task {
            // TODO: Remove this
            do {
                let client = PokeAPIClient(session: URLSession.shared)
                
                let page0 = try await client.get(resourceURL: Endpoint.pokemon)
                let firstResult = page0.results.first!
                
                let bulbasaur = try await client.get(resource: firstResult)
                
                imageURL = bulbasaur.spriteURL(for: .officialArtwork)
            } catch {
                //
            }
        }
    }
}

#Preview {
    ContentView()
}
