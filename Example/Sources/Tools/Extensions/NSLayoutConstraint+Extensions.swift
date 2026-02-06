#if canImport(UIKit)
import UIKit

extension NSLayoutConstraint {

    @discardableResult
    internal func activate() -> Self {
        self.isActive = true

        return self
    }
}
#endif
