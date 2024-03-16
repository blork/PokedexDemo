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
    
    func testSnapshotPokemonDetailScreen() throws {
        asssertScreenSnapshot(
            of: PokemonDetailScreen(
                viewModel: .Preview(
                    pokemon: .preview(),
                    additionalInfo: .loading
                )
            ),
            layout: .fixed(width: 390, height: 1080)
        )
        asssertScreenSnapshot(
            of: PokemonDetailScreen(
                viewModel: .Preview(
                    pokemon: .preview(),
                    additionalInfo: .loaded(
                        .preview
                    )
                )
            ),
            layout: .fixed(width: 390, height: 1080)
        )
        asssertScreenSnapshot(
            of: PokemonDetailScreen(
                viewModel: .Preview(
                    pokemon: .preview(),
                    additionalInfo: .error(
                        PreviewError.whoops
                    )
                )
            ),
            layout: .fixed(width: 390, height: 1080)
        )
    }
    
    private func asssertScreenSnapshot(
        of value: some View,
        layout: SwiftUISnapshotLayout = .device(config: .iPhone13),
        file: StaticString = #file,
        testName: String = #function,
        line: UInt = #line
    ) {
        assertSnapshot(
            of: value,
            as: .image(precision: 0.99, layout: layout),
            file: file,
            testName: testName,
            line: line
        )
    }
}
