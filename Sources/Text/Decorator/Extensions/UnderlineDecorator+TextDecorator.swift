#if canImport(UIKit)
import Foundation

extension UnderlineDecorator: TokenTraitProvider where Value == TypographyValue { }
extension UnderlineDecorator: TextDecorator where Value == TypographyValue { }

extension Text {

    public func underline(_ underline: TypographyLineToken? = .single) -> Self {
        decorated(by: UnderlineDecorator(underline: underline))
    }
}
#endif
