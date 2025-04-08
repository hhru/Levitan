#if canImport(UIKit)
import UIKit

extension CGSize {

    internal func isEqual(to other: Self, threshold: CGFloat) -> Bool {
        abs(width - other.width) < threshold && abs(height - other.height) < threshold
    }

    internal func inset(by insets: UIEdgeInsets) -> Self {
        Self(
            width: width - insets.horizontal,
            height: height - insets.vertical
        )
    }

    internal func outset(by insets: UIEdgeInsets) -> Self {
        Self(
            width: width + insets.horizontal,
            height: height + insets.vertical
        )
    }
}
#endif
