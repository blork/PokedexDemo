import Foundation
import PokeAPI

public struct Pokemon: Identifiable, Hashable {
    public let id: Int
    public let name: String
    public let baseExperience: Int
    public let height: Int
    public let weight: Int
    
    init(id: Int, name: String, baseExperience: Int, height: Int, weight: Int) {
        self.id = id
        self.name = name
        self.baseExperience = baseExperience
        self.height = height
        self.weight = weight
    }
    
    init(_ pokemon: PokeAPI.Pokemon) {
        self.init(
            id: pokemon.id,
            name: pokemon.name,
            baseExperience: pokemon.baseExperience,
            height: pokemon.height,
            weight: pokemon.weight
        )
    }
}

extension Pokemon {
    static func preview(id: Int = 1) -> Self {
        .init(id: id, name: "Pokemon \(id)", baseExperience: 1, height: 2, weight: 3)
    }
}

extension [Pokemon] {
    static var preview: Self {
        (0..<20).map { .preview(id: $0) }
    }
}
