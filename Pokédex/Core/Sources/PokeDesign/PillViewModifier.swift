import SwiftUI

struct PillViewModifier: ViewModifier {
    
    var foregroundColor: Color
    var background: Color
    
    @ScaledMetric var verticalPadding = 4
    @ScaledMetric var horizontalPadding = 6

    func body(content: Content) -> some View {
        content
            .foregroundColor(foregroundColor)
            .padding(.vertical, verticalPadding)
            .padding(.horizontal, horizontalPadding)
            .background(background)
            .cornerRadius(.cornerRadius(.regular))
    }
}

public extension View {
    func pill(foregroundColor: Color, backgroundColor: Color) -> some View {
        modifier(PillViewModifier(
            foregroundColor: foregroundColor,
            background: backgroundColor
        ))
    }
}

#Preview {
    Label("Pokemon", systemImage: "circle")
        .font(.caption)
        .pill(foregroundColor: .white, backgroundColor: .red)
        .previewDisplayName("Label")
}
