#if canImport(UIKit)
import UIKit

extension AlignmentDecorator: TokenTraitProvider where Value == TypographyValue { }
extension AlignmentDecorator: TextDecorator where Value == TypographyValue { }

extension Text {

    public func alignment(_ alignment: NSTextAlignment?) -> Self {
        decorated(by: AlignmentDecorator(alignment: alignment))
    }
}
#endif
