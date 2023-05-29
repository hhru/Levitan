import Foundation

public protocol TokenTraitProvider {

    var traits: [TokenTrait] { get }
}

extension TokenTraitProvider where Self: Sendable & Hashable {

    public var traits: [TokenTrait] {
        [TokenTrait(self)]
    }
}

extension Optional: TokenTraitProvider where Wrapped: TokenTraitProvider {

    public var traits: [TokenTrait] {
        self?.traits ?? []
    }
}

extension Array: TokenTraitProvider where Element: TokenTraitProvider {

    public var traits: [TokenTrait] {
        map { TokenTrait($0.traits) }
    }
}

extension Set: TokenTraitProvider where Element: TokenTraitProvider {

    public var traits: [TokenTrait] {
        map { TokenTrait($0.traits) }
    }
}
