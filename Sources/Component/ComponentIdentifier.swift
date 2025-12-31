#if canImport(UIKit)
import Foundation

public struct ComponentIdentifier: Hashable, @unchecked Sendable {

    public let value: AnyHashable
    public let traits: AnyHashable?

    private init(
        _ value: AnyHashable,
        traits: AnyHashable? = nil
    ) {
        self.value = value
        self.traits = traits
    }

    public init(
        _ value: some Hashable & Sendable,
        traits: some Hashable & Sendable
    ) {
        self.init(
            value as AnyHashable,
            traits: traits as AnyHashable
        )
    }

    public init(_ value: some Hashable & Sendable) {
        self.init(value as AnyHashable)
    }

    public func traits(_ traits: some Hashable & Sendable) -> Self {
        Self(value, traits: traits)
    }
}
#endif
