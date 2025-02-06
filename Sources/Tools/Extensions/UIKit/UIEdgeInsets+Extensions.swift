#if canImport(UIKit)
import UIKit

extension UIEdgeInsets {

    internal var horizontal: CGFloat {
        left + right
    }

    internal var vertical: CGFloat {
        top + bottom
    }

    internal init(all value: CGFloat) {
        self.init(
            top: value,
            left: value,
            bottom: value,
            right: value
        )
    }
}
#endif
