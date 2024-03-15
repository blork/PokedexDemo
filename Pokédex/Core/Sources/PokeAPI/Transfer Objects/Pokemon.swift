import Foundation

public struct Pokemon: Decodable, Identifiable {
    public let id: Int
    public let name: String
    public let baseExperience: Int
    public let height: Int
    public let weight: Int
    public let abilities: [PokeAbility]
    public let moves: [PokeMove]
    
    public struct PokeAbility: Decodable {
        let isHidden: Bool
        let slot: Int
        let ability: Resource<Ability>
    }
    
    public struct PokeMove: Decodable {
        let move: Resource<Move>
        let versionGroupDetails: [PokeMoveVersion]
    }

    public struct PokeMoveVersion: Decodable {
        let levelLearnedAt: Int
        let versionGroup: Resource<VersionGroup>
        let moveLearnMethod: Resource<MoveLearnMethod>
    }
}

public extension Pokemon {
    private static let spriteBase = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/"
    
    enum Sprite: String {
        case back
        case front
        case officialArtwork = "other/official-artwork"
    }
    
    func spriteURL(for sprite: Sprite) -> URL {
        var components = URLComponents(string: Pokemon.spriteBase)!
        components.path += sprite.rawValue
        components.path += "/\(id).png"
        return components.url!
    }
}

public struct Ability: Decodable {
    public let id: Int
    public let name: String
}

public struct Move: Decodable {
    public let id: Int
    public let name: String
}

public struct VersionGroup: Decodable {
    public let id: Int
    public let name: String
}

public struct MoveLearnMethod: Decodable {
    public let id: Int
    public let name: String
}

public extension Pokemon {
    static var preview: Pokemon {
        .init(
            id: 1,
            name: "bulbasaur",
            baseExperience: 64,
            height: 7,
            weight: 67,
            abilities: [
                .init(
                    isHidden: false,
                    slot: 1,
                    ability: .init(
                        name: "overgrow",
                        url: .init(
                            url: URL(
                                string: "https://pokeapi.co/api/v2/ability/65/"
                            )!
                        )
                    )
                ),
            ],
            moves: [
                .init(
                    move: .init(
                        name: "razor-wind",
                        url: .init(url: URL(string: "https://pokeapi.co/api/v2/move/13/")!)
                    ),
                    versionGroupDetails: [
                        .init(
                            levelLearnedAt: 0,
                            versionGroup: .init(
                                name: "gold-silver",
                                url: .init(
                                    url: URL(
                                        string: "https://pokeapi.co/api/v2/version-group/3/"
                                    )!
                                )
                            ),
                            moveLearnMethod: .init(
                                name: "egg",
                                url: .init(
                                    url: URL(
                                        string: "https://pokeapi.co/api/v2/move-learn-method/2/"
                                    )!
                                )
                            )
                        ),
                    ]
                ),
            ]
        )
    }
}
