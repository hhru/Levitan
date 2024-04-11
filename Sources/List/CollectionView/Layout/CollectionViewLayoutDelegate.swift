import UIKit

internal protocol CollectionViewLayoutDelegate: UICollectionViewDelegate {

    func collectionViewLayoutContext(
        _ collectionViewLayout: UICollectionViewLayout
    ) -> ComponentContext?

    func collectionViewLayout(
        _ collectionViewLayout: UICollectionViewLayout,
        metricsForSectionAt index: Int
    ) -> Any?

    func collectionViewLayout(
        _ collectionViewLayout: UICollectionViewLayout,
        hasHeaderAt index: Int
    ) -> Bool

    func collectionViewLayout(
        _ collectionViewLayout: UICollectionViewLayout,
        hasFooterAt index: Int
    ) -> Bool

    func collectionViewLayout(
        _ collectionViewLayout: UICollectionViewLayout,
        sizingForItemAt indexPath: IndexPath,
        fitting size: CGSize
    ) -> ComponentSizing?

    func collectionViewLayout(
        _ collectionViewLayout: UICollectionViewLayout,
        sizingForHeaderAt index: Int,
        fitting size: CGSize
    ) -> ComponentSizing?

    func collectionViewLayout(
        _ collectionViewLayout: UICollectionViewLayout,
        sizingForFooterAt index: Int,
        fitting size: CGSize
    ) -> ComponentSizing?
}
