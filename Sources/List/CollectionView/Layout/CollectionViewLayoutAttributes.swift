#if canImport(UIKit)
import UIKit

internal final class CollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {

    internal var sizing: CollectionViewLayoutSizing?

    internal override func copy(with zone: NSZone? = nil) -> Any {
        let copy = super.copy(with: zone)

        if let copy = copy as? Self {
            copy.sizing = sizing
        }

        return copy
    }

    internal override func isEqual(_ other: Any?) -> Bool {
        guard super.isEqual(other) else {
            return false
        }

        guard let other = other as? Self else {
            return false
        }

        return sizing == other.sizing
    }

    internal func shouldUpdate(preferring attributes: UICollectionViewLayoutAttributes) -> Bool {
        guard sizing != nil else {
            return false
        }

        return !frame.size.isEqual(to: attributes.frame.size, threshold: 1.0)
    }

    internal func update(preferring attributes: UICollectionViewLayoutAttributes) {
        frame.size = attributes.frame.size
    }
}
#endif
