import Foundation
import PokeAPI

public struct Pokemon: Identifiable, Hashable {
    public let id: Int
    public let name: String
    public let baseExperience: Int
    public let height: Measurement<UnitLength>
    public let weight: Measurement<UnitMass>
    
    init(id: Int, name: String, baseExperience: Int, height: Int, weight: Int) {
        self.id = id
        self.name = name
        self.baseExperience = baseExperience
        self.height = .init(value: Double(height), unit: .decimeters)
        self.weight = .init(value: Double(weight * 100), unit: .grams)
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
    
    public struct AdditionalInfo: Hashable {
        let abilities: [Ability]
        let moves: [Move]
        
        init(abilities: [Ability], moves: [Move]) {
            self.abilities = abilities
            self.moves = moves
        }
        
        init(abilities: [PokeAPI.Ability], moves: [PokeAPI.Move]) {
            self.abilities = abilities.map { ability in
                .init(
                    name: ability.names.first { name in
                        name.language.name == Locale.current.language.languageCode?.identifier
                    }?.name ?? ability.name,
                    description: ability.effectEntries.first { effect in
                        effect.language.name == Locale.current.language.languageCode?.identifier
                    }?.shortEffect ?? "N/A"
                )
            }
            self.moves = moves.map { move in
                .init(
                    name: move.names.first { name in
                        name.language.name == Locale.current.language.languageCode?.identifier
                    }?.name ?? move.name,
                    accuracy: move.accuracy,
                    pp: move.pp
                )
            }
        }

        public struct Ability: Hashable {
            public let name: String
            public let description: String
        }

        public struct Move: Hashable, Identifiable {
            public var id: String { name }
            public let name: String
            public let accuracy: Int?
            public let pp: Int
        }
    }
}

extension Pokemon {
    private static let spriteBase = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/"
    
    enum Sprite: String {
        case back
        case front = ""
        case officialArtwork = "other/official-artwork"
    }
    
    func spriteURL(for sprite: Sprite) -> URL {
        var components = URLComponents(string: Pokemon.spriteBase)!
        components.path += sprite.rawValue
        components.path += "/\(id).png"
        return components.url!
    }
}

extension Pokemon {
    static func preview(id: Int = 1) -> Self {
        .init(id: id, name: "Pokemon \(id)", baseExperience: 1, height: 2, weight: 3)
    }
}

extension [Pokemon] {
    static var preview: Self {
        (0 ..< 20).map { .preview(id: $0) }
    }
}

extension Pokemon.AdditionalInfo {
    static var preview: Self {
        .init(
            abilities: [
                .init(name: "Ability", description: "Has a 10% chance of making target Pokémon [flinch]{mechanic:flinch} with each hit."),
            ],
            moves: [
                .init(name: "Move", accuracy: 100, pp: 15)
            ]
        )
    }
}
