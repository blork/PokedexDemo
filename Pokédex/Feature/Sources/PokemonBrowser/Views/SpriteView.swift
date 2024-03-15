import SwiftUI

struct SpriteView: View {
    
    let url: URL
    
    @ScaledMetric(relativeTo: .title) private var imageSize = 64
    
    var body: some View {
        AsyncImage(url: url) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
        } placeholder: {
            Color(.tertiarySystemFill)
        }
        .background(Color(.tertiarySystemFill))
        .frame(width: imageSize, height: imageSize)
        .clipShape(.rect(cornerRadius: .cornerRadius(.regular)))
        .overlay(
            RoundedRectangle(cornerRadius: .cornerRadius(.regular))
                .stroke(Color(.systemFill), lineWidth: 1)
        )
    }
}

#Preview {
    SpriteView(url: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/35.png")!)
}
