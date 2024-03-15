import Foundation

public enum Dimensions {
    public enum CornerRadius: CGFloat {
        case regular = 8
    }
}

public extension CGFloat {
    static func cornerRadius(_ cornerRadius: Dimensions.CornerRadius) -> CGFloat {
        cornerRadius.rawValue
    }
}
