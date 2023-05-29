import Foundation

internal struct OutsetsDecorator<Value: DecorableByOutsets>: TokenDecorator {

    internal let outsets: InsetsToken

    internal func decorate(_ value: Value, theme: TokenTheme) -> Value {
        value.outset(by: outsets.resolve(for: theme))
    }
}

extension Token where Value: DecorableByOutsets {

    public func outset(by outsets: InsetsToken) -> Self {
        decorated(by: OutsetsDecorator(outsets: outsets))
    }

    public func outset(_ edge: InsetsEdge, _ value: SpacingToken) -> Self {
        outset(by: InsetsToken(edge, value))
    }

    public func outset(by value: SpacingToken) -> Self {
        outset(by: InsetsToken(all: value))
    }

    public func outsetBy(
        top: SpacingToken = .zero,
        leading: SpacingToken = .zero,
        bottom: SpacingToken = .zero,
        trailing: SpacingToken = .zero
    ) -> Self {
        outset(
            by: InsetsToken(
                top: top,
                leading: leading,
                bottom: bottom,
                trailing: trailing
            )
        )
    }
}
