#if canImport(UIKit)
import UIKit

extension NSLayoutConstraint {

    @discardableResult
    func activate() -> Self {
        self.isActive = true

        return self
    }
}
#endif
