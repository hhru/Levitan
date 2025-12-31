#if canImport(UIKit)
import Foundation

public struct FlowIdentifier: Hashable, @unchecked Sendable {

    public let value: AnyHashable
    public let traits: AnyHashable?

    internal init(_ value: some Hashable & Sendable) {
        self.value = value
        self.traits = nil
    }

    internal init(_ value: some Hashable & Sendable, traits: some Hashable & Sendable) {
        self.value = value
        self.traits = traits
    }
}
#endif
