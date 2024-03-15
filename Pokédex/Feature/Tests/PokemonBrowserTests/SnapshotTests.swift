import Base
@testable import PokemonBrowser
import SnapshotTesting
import SwiftUI
import XCTest

final class SnapshotTests: XCTestCase {
    
    func testSnapshotPokemonListScreen() throws {
        asssertScreenSnapshot(of: PokemonListScreen(viewModel: .Preview(.loading)))
        asssertScreenSnapshot(of: PokemonListScreen(viewModel: .Preview(.loaded(.preview))))
        asssertScreenSnapshot(of: PokemonListScreen(viewModel: .Preview(.error(PreviewError.whoops))))
    }
    
    private func asssertScreenSnapshot(
        of value: some View,
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) {
        assertSnapshot(
            of: NavigationStack { value },
            as: .image(precision: 0.99, layout: .device(config: .iPhone13)),
            file: file,
            testName: testName,
            line: line
        )
    }
}
