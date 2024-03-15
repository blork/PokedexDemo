import Foundation

public extension String {
    static let lipsum = """
    Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur in pretium sem, ac cursus nisl.
    Donec eu tempor libero, non fringilla neque. Phasellus molestie dignissim justo ac lacinia.
    Vivamus eget ullamcorper enim. Suspendisse a est molestie, gravida purus vitae, luctus diam.
    Fusce pharetra leo non egestas ultrices. Cras sagittis egestas erat.
    Ut volutpat felis erat, ut laoreet mauris bibendum eget.
    """
    
    static var randomID: String {
        UUID().uuidString
    }
}

public enum PreviewError: Error {
    case whoops
}
