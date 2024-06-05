import UIKit

extension UICollectionView {

    internal var contentBoundsSize: CGSize {
        let insets = adjustedContentInset

        return CGSize(
            width: max(frame.width - insets.horizontal, .zero),
            height: max(frame.height - insets.vertical, .zero)
        )
    }

    internal var contentBounds: CGRect {
        let insets = adjustedContentInset

        return CGRect(
            x: bounds.minX + insets.left,
            y: bounds.minY + insets.top,
            width: max(bounds.width - insets.horizontal, .zero),
            height: max(bounds.height - insets.vertical, .zero)
        )
    }

    internal func containsIndexPath(_ indexPath: IndexPath) -> Bool {
        (indexPath.section < numberOfSections) && (indexPath.item < numberOfItems(inSection: indexPath.section))
    }

    internal func reloadData(completion: @escaping () -> Void) {
        reloadData()

        DispatchQueue.main.async(execute: completion)
    }
}
