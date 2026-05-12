#if canImport(UIKit)
import Foundation

public protocol TextDecorator: TokenTraitProvider, Hashable, Sendable {

    func decorate(
        typography: TypographyValue,
        context: TextContext
    ) -> TypographyValue
}

extension TextDecorator where
    Self: TokenDecorator,
    Input == TypographyValue,
    Output == TypographyValue {

    public func decorate(typography: TypographyValue, context: TextContext) -> TypographyValue {
        decorate(typography, theme: context.tokenTheme)
    }
}

extension Array: TextDecorator where Element: TextDecorator {

    public func decorate(typography: TypographyValue, context: TextContext) -> TypographyValue {
        reduce(typography) { typography, decorator in
            decorator.decorate(
                typography: typography,
                context: context
            )
        }
    }
}
#endif
