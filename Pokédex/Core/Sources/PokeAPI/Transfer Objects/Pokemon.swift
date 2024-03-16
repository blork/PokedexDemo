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
        public let isHidden: Bool
        public let slot: Int
        public let ability: Resource<Ability>
    }
    
    public struct PokeMove: Decodable {
        public let move: Resource<Move>
        public let versionGroupDetails: [PokeMoveVersion]
    }

    public struct PokeMoveVersion: Decodable {
        public let levelLearnedAt: Int
        public let versionGroup: Resource<VersionGroup>
        public let moveLearnMethod: Resource<MoveLearnMethod>
    }
}

public struct Ability: Decodable {
    public let id: Int
    public let name: String
    public let names: [Name]
    public let effectEntries: [Effect]
}

public struct Move: Decodable {
    public let id: Int
    public let name: String
    public let accuracy: Int?
    public let pp: Int
    public let names: [Name]
}

public struct VersionGroup: Decodable {
    public let id: Int
    public let name: String
}

public struct MoveLearnMethod: Decodable {
    public let id: Int
    public let name: String
}

public struct Name: Decodable {
    public let name: String
    public let language: Resource<Language>
}

public struct Language: Decodable {
    public let iso639: String
}

public struct Effect: Decodable {
    public let effect: String
    public let shortEffect: String
    public let language: Resource<Language>
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
