#if canImport(UIKit1)
import Foundation

extension StrikethroughDecorator: TokenTraitProvider where Value == TypographyValue { }
extension StrikethroughDecorator: TextDecorator where Value == TypographyValue { }

extension Text2 {

    public func strikethrough(_ strikethrough: TypographyLineToken? = .single) -> Self {
        decorated(by: StrikethroughDecorator(strikethrough: strikethrough))
    }
}
#endif
