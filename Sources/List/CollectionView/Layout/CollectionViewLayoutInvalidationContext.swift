import UIKit

internal final class CollectionViewLayoutInvalidationContext: UICollectionViewLayoutInvalidationContext {

    internal var invalidateContainerSize = false

    internal var itemsPreferredAttributes: [IndexPath: UICollectionViewLayoutAttributes] = [:]
    internal var headersPreferredAttributes: [IndexPath: UICollectionViewLayoutAttributes] = [:]
    internal var footersPreferredAttributes: [IndexPath: UICollectionViewLayoutAttributes] = [:]

    internal func invalidateItem(
        at indexPath: IndexPath,
        preferring attributes: UICollectionViewLayoutAttributes
    ) {
        itemsPreferredAttributes[indexPath] = attributes
    }

    internal func invalidateHeader(
        at indexPath: IndexPath,
        preferring attributes: UICollectionViewLayoutAttributes
    ) {
        headersPreferredAttributes[indexPath] = attributes
    }

    internal func invalidateFooter(
        at indexPath: IndexPath,
        preferring attributes: UICollectionViewLayoutAttributes
    ) {
        footersPreferredAttributes[indexPath] = attributes
    }
}
