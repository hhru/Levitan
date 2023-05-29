import Foundation

internal struct InsetsDecorator<Value: DecorableByInsets>: TokenDecorator {

    internal let insets: InsetsToken

    internal func decorate(_ value: Value, theme: TokenTheme) -> Value {
        value.inset(by: insets.resolve(for: theme))
    }
}

extension Token where Value: DecorableByInsets {

    public func inset(by insets: InsetsToken) -> Self {
        decorated(by: InsetsDecorator(insets: insets))
    }

    public func inset(_ edge: InsetsEdge, _ value: SpacingToken) -> Self {
        inset(by: InsetsToken(edge, value))
    }

    public func inset(by value: SpacingToken) -> Self {
        inset(by: InsetsToken(all: value))
    }

    public func insetBy(
        top: SpacingToken = .zero,
        leading: SpacingToken = .zero,
        bottom: SpacingToken = .zero,
        trailing: SpacingToken = .zero
    ) -> Self {
        inset(
            by: InsetsToken(
                top: top,
                leading: leading,
                bottom: bottom,
                trailing: trailing
            )
        )
    }
}
