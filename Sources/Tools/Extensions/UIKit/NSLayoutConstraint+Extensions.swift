import UIKit

extension NSLayoutConstraint {

    @discardableResult
    internal func priority(_ priority: UILayoutPriority) -> Self {
        self.priority = priority

        return self
    }

    @discardableResult
    internal func activate() -> Self {
        self.isActive = true

        return self
    }
}
