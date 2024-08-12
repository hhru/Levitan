import Foundation

extension StrikethroughDecorator: TokenTraitProvider where Value == TypographyValue { }
extension StrikethroughDecorator: TextDecorator where Value == TypographyValue { }

extension Text {

    public func strikethrough(_ strikethrough: TypographyLineToken? = .single) -> Self {
        decorated(by: StrikethroughDecorator(strikethrough: strikethrough))
    }
}
