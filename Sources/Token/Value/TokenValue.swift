import Foundation

public protocol TokenValue: Hashable, TokenTraitProvider { }

extension TokenValue {

    public var token: Token<Self> {
        .value(self)
    }
}
