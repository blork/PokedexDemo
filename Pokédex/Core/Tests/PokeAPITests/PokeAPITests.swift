@testable import PokeAPI
import XCTest

final class PokeAPITests: XCTestCase {
    
    func test_anyRequestIsPerformed_invalidStatusCode_errorIsThrown() async throws {
        let session = StubSession()
        session.response = (Data(), 404)
        
        let client = PokeAPIClient(session: session)
        
        do {
            let _: String = try await client.perform(URLRequest(url: URL(string: "http://example.com")!))
        } catch let ClientError.unexpected(response) {
            XCTAssertEqual(response.statusCode, 404)
        } catch {
            XCTFail()
        }
    }
    
    func test_anyRequestIsPerformed_invalidResponseObject_errorIsThrown() async throws {
        let session = StubSession()
        session.response = (Data(), 200)
        
        let client = PokeAPIClient(session: session)
        
        do {
            let _: String = try await client.perform(URLRequest(url: URL(string: "http://example.com")!))
        } catch let ClientError.unknown(error) {
            XCTAssertTrue(error is DecodingError)
        } catch {
            XCTFail()
        }
    }
    
    func test_pokemon_successful_responseIsReturned() async throws {
        let session = StubSession()
        
        session.response = ("""
        {
          "count": 1302,
          "next": "https://pokeapi.co/api/v2/pokemon/?offset=20&limit=20",
          "previous": null,
          "results": [
            {
              "name": "bulbasaur",
              "url": "https://pokeapi.co/api/v2/pokemon/1/"
            }
          ]
        }
        """.data(using: .utf8)!, 200)
        
        let client = PokeAPIClient(session: session)

        let response = try await client.get(resourceURL: Endpoint.pokemon)

        XCTAssertEqual(response.count, 1302)
        XCTAssertEqual(response.next!.rawValue.absoluteString, "https://pokeapi.co/api/v2/pokemon/?offset=20&limit=20")
        XCTAssertNil(response.previous)
        
        let pokemon = response.results.first!
        XCTAssertEqual(pokemon.name, "bulbasaur")
        XCTAssertEqual(pokemon.url.rawValue.absoluteString, "https://pokeapi.co/api/v2/pokemon/1/")
    }
    
    func test_resource_successful_responseIsReturned() async throws {
        let bulbasaur = Resource<Pokemon>(name: "bulbasaur", url: .init(url: URL(string: "https://example.com/")!))
        
        let session = StubSession()
        session.response = ("""
        {
          "abilities": [
            {
              "ability": {
                "name": "overgrow",
                "url": "https://pokeapi.co/api/v2/ability/65/"
              },
              "is_hidden": false,
              "slot": 1
            },
          ],
          "base_experience": 64,
          "cries": {
            "latest": "https://raw.githubusercontent.com/PokeAPI/cries/main/cries/pokemon/latest/1.ogg",
            "legacy": "https://raw.githubusercontent.com/PokeAPI/cries/main/cries/pokemon/legacy/1.ogg"
          },
          "forms": [
            {
              "name": "bulbasaur",
              "url": "https://pokeapi.co/api/v2/pokemon-form/1/"
            }
          ],
          "game_indices": [
            {
              "game_index": 153,
              "version": {
                "name": "red",
                "url": "https://pokeapi.co/api/v2/version/1/"
              }
            },
          ],
          "height": 7,
          "held_items": [],
          "id": 1,
          "is_default": true,
          "location_area_encounters": "https://pokeapi.co/api/v2/pokemon/1/encounters",
          "moves": [
            {
              "move": {
                "name": "razor-wind",
                "url": "https://pokeapi.co/api/v2/move/13/"
              },
              "version_group_details": [
                {
                  "level_learned_at": 0,
                  "move_learn_method": {
                    "name": "egg",
                    "url": "https://pokeapi.co/api/v2/move-learn-method/2/"
                  },
                  "version_group": {
                    "name": "gold-silver",
                    "url": "https://pokeapi.co/api/v2/version-group/3/"
                  }
                },
                {
                  "level_learned_at": 0,
                  "move_learn_method": {
                    "name": "egg",
                    "url": "https://pokeapi.co/api/v2/move-learn-method/2/"
                  },
                  "version_group": {
                    "name": "crystal",
                    "url": "https://pokeapi.co/api/v2/version-group/4/"
                  }
                }
              ]
            },
          ],
          "name": "bulbasaur",
          "order": 1,
          "past_abilities": [],
          "past_types": [],
          "species": {
            "name": "bulbasaur",
            "url": "https://pokeapi.co/api/v2/pokemon-species/1/"
          },
          "stats": [
            {
              "base_stat": 45,
              "effort": 0,
              "stat": {
                "name": "hp",
                "url": "https://pokeapi.co/api/v2/stat/1/"
              }
            },
            {
              "base_stat": 49,
              "effort": 0,
              "stat": {
                "name": "attack",
                "url": "https://pokeapi.co/api/v2/stat/2/"
              }
            },
            {
              "base_stat": 49,
              "effort": 0,
              "stat": {
                "name": "defense",
                "url": "https://pokeapi.co/api/v2/stat/3/"
              }
            },
            {
              "base_stat": 65,
              "effort": 1,
              "stat": {
                "name": "special-attack",
                "url": "https://pokeapi.co/api/v2/stat/4/"
              }
            },
            {
              "base_stat": 65,
              "effort": 0,
              "stat": {
                "name": "special-defense",
                "url": "https://pokeapi.co/api/v2/stat/5/"
              }
            },
            {
              "base_stat": 45,
              "effort": 0,
              "stat": {
                "name": "speed",
                "url": "https://pokeapi.co/api/v2/stat/6/"
              }
            }
          ],
          "types": [
            {
              "slot": 1,
              "type": {
                "name": "grass",
                "url": "https://pokeapi.co/api/v2/type/12/"
              }
            },
            {
              "slot": 2,
              "type": {
                "name": "poison",
                "url": "https://pokeapi.co/api/v2/type/4/"
              }
            }
          ],
          "weight": 69
        }
        """.data(using: .utf8)!, 200)

        let client = PokeAPIClient(session: session)

        let response = try await client.get(resource: bulbasaur)
        XCTAssertEqual(response.name, "bulbasaur")
        
        XCTAssertEqual(response.id, 1)
        XCTAssertEqual(response.baseExperience, 64)
        XCTAssertEqual(response.weight, 69)
        XCTAssertEqual(response.height, 7)
        XCTAssertEqual(response.abilities.count, 1)
        XCTAssertEqual(response.moves.count, 1)
    }
}
