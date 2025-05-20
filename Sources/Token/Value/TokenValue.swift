import Foundation

public protocol TokenValue: Hashable, Sendable, TokenTraitProvider { }

extension TokenValue {

    public var token: Token<Self> {
        .value(self)
    }
}
