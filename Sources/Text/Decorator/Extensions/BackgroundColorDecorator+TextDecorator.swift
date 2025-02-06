#if canImport(UIKit1)
import Foundation

extension BackgroundColorDecorator: TokenTraitProvider where Value == TypographyValue { }
extension BackgroundColorDecorator: TextDecorator where Value == TypographyValue { }

extension Text2 {

    public func backgroundColor(_ backgroundColor: ColorToken?) -> Self {
        decorated(by: BackgroundColorDecorator(backgroundColor: backgroundColor))
    }
}
#endif
