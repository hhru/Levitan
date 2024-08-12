import Foundation

extension BackgroundColorDecorator: TokenTraitProvider where Value == TypographyValue { }
extension BackgroundColorDecorator: TextDecorator where Value == TypographyValue { }

extension Text {

    public func backgroundColor(_ backgroundColor: ColorToken?) -> Self {
        decorated(by: BackgroundColorDecorator(backgroundColor: backgroundColor))
    }
}
