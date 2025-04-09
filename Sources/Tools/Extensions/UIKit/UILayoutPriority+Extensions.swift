#if canImport(UIKit)
import UIKit

extension UILayoutPriority {

    internal static var almostRequired: Self {
        Self(rawValue: required.rawValue - 1)
    }
}
#endif
