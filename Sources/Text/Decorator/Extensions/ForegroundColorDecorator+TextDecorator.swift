#if canImport(UIKit)
import Foundation

extension ForegroundColorDecorator: TokenTraitProvider where Value == TypographyValue { }
extension ForegroundColorDecorator: TextDecorator where Value == TypographyValue { }

extension Text {

    public func foregroundColor(_ foregroundColor: ColorToken?) -> Self {
        decorated(by: ForegroundColorDecorator(foregroundColor: foregroundColor))
    }
}
#endif
