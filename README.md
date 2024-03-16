# Pokédex App

**Developed in Xcode 15.1**

This is a sample application which uses the Pokemon API (https://pokeapi.co). The project is intended to show a modern SwiftUI app, with an MVVM architecture with a high degree of modularisation and testability. Many of the choices are overkill for an application of this size, but serve to illustrate a solid foundation upon which a larger app could be sustainably grown.

This project reflects around 8 hours of effort.

The app is composed of 4 modules/packages split over 3 layers:

- Base Layer
	- Base
		- Contains utility methods and classes
	
- Core Layer
	- API
		- Contains networking code, such as creating and performing requests, and decoding responses into structs.
	- Design
		- Contains shared design code, such as styles, design values, and commonly shared stand-alone views.
	
- Feature Layer
	- Pokemon Browser
		- A list of Pokémon with search functionality and a detail page.
	
The feature is then imported by the main app target ("Pokédex") and composed into a main window. The idea is that, with additional features, each feature could occupy a tab in a tabview, with each being the "root view" of the feature. The features could be composed in many other ways, though, such as a "Settings" feature being shown modally.

There is also an additional "mini app" target ("FeaturePokemonBrowserMiniApp") which allows a feature to be launched directly and independently of any another. This can be very useful in development, when you want to jump directly to the feature you are working on. As there's only one feature here, the difference isn't really felt, although FeaturePokemonBrowserMiniApp has a stub networking stack setup, so it doesn't actually hit the PokeAPI. It also has a different accent colour.

The features are composed of multiple SwiftUI Views named as "Screens" for clarity. Each of these has a ViewModel which performs the specific logic needed for thew view. This often takes the form of network requests which are performed by specific Repositories. These take the network requests from the API package and transform the decoded API structs into Model objects for consumption by views. In this example multiple requests are required to combine the basic details of a Pokémon which are returned in a list with extra info such as height and weight. Subsequently more requests are needed to fetch moves and abilities. The repo batches up these requests using withThrowingTaskGroup, so that the final object is flattened and simplified, and at the point of use is a single async function.

By having the separation of ViewModel and Repository, Unit Testing the VMs becomes simple as they can be provided Stub/Fake/Mock repos which return specific data in test, so simple assertions can be made. In this example, the repository has a protocol which is conformed to by a "real" implementation and also a "stub" version.

Dependency injection is managed manually by having each object take its dependencies as constructor arguments. As an app scales, this could be unwieldy, but it is explicit and clear. I have experience with DI frameworks in Swift, but felt them not needed here.

The project makes use of Unit Tests for logic and Snapshot tests for UI, using the [SnapshotTesting](https://github.com/pointfreeco/swift-snapshot-testing) library.

Additionally, the app is multi-platform, as this is very easy to enable for a fully SwiftUI app. It runs on iPhone, iPad, and macOS. The UI leaves something to be desired as a Mac app, as I have done very little to make it feel more "native", but it works and is a good starting point.
