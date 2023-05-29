import Foundation

public struct TokenTrait:
    @unchecked Sendable,
    Hashable,
    ExpressibleByStringLiteral {

    public let value: AnyHashable

    public init(_ value: some Sendable & Hashable) {
        self.value = value
    }

    public init(stringLiteral value: String) {
        self.init(value)
    }
}
