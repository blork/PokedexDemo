import SwiftUI

struct PokemonRow: View {
    
    let pokemon: Pokemon
    
    var body: some View {
        HStack {
            SpriteView(url: pokemon.spriteURL(for: .front))

            Text(pokemon.name.capitalized)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.headline)
            
            Spacer()
            
            Text(String(format: "#%04d", pokemon.id))
                .font(.caption.bold().monospacedDigit())
                .pill(foregroundColor: .white, backgroundColor: .accentColor)
        }
    }
}


#Preview {
    PokemonRow(pokemon: .preview())
        .padding()
}
