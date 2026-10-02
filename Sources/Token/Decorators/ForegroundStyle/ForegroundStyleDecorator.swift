import Foundation

internal struct ForegroundStyleDecorator<Value: DecorableByForegroundStyle>: TokenDecorator {

    internal let primaryColor: ColorToken
    internal let secondaryColor: ColorToken?
    internal let tertiaryColor: ColorToken?

    internal func decorate(_ value: Value, theme: TokenTheme) -> Value {
        value
            .foregroundStyle(
                primaryColor.resolve(for: theme),
                secondaryColor?.resolve(for: theme),
                tertiaryColor?.resolve(for: theme)
            )
    }
}

extension Token where Value: DecorableByForegroundStyle {

    public func foregroundStyle(
        _ primaryColor: ColorToken,
        _ secondaryColor: ColorToken? = nil,
        _ tertiaryColor: ColorToken? = nil
    ) -> Self {
        decorated(
            by: ForegroundStyleDecorator(
                primaryColor: primaryColor,
                secondaryColor: secondaryColor,
                tertiaryColor: tertiaryColor
            )
        )
    }
}
