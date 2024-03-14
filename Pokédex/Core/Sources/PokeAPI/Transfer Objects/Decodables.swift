import Foundation

public struct ResourceList<T: Decodable>: Decodable {
    public let count: Int
    public let next: ResourceURL<Self>?
    public let previous: ResourceURL<Self>?
    public let results: [Resource<T>]
}

public struct ResourceURL<T: Decodable>: Decodable {
    let url: URL

    init(url: URL) {
        self.url = url
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        url = try container.decode(URL.self)
    }
}

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

public struct Resource<T: Decodable>: Decodable {
    public let name: String
    public let url: URL
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
