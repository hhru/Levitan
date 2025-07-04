#if canImport(UIKit)
import Foundation

public protocol TextDecorator: TokenTraitProvider, Hashable, Sendable {

    func decorate(
        typography: TypographyValue,
        context: ComponentContext
    ) -> TypographyValue
}

extension TextDecorator where
    Self: TokenDecorator,
    Input == TypographyValue,
    Output == TypographyValue {

    public func decorate(typography: TypographyValue, context: ComponentContext) -> TypographyValue {
        decorate(typography, theme: context.tokenTheme)
    }
}

extension TextDecorator {

    internal func isEqual(to other: any TextDecorator) -> Bool {
        guard let other = other as? Self else {
            return false
        }

        return self == other
    }
}

extension Array: TextDecorator where Element: TextDecorator {

    public func decorate(typography: TypographyValue, context: ComponentContext) -> TypographyValue {
        reduce(typography) { typography, decorator in
            decorator.decorate(
                typography: typography,
                context: context
            )
        }
    }
}
#endif
