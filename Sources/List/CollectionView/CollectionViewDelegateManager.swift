#if canImport(UIKit)
import UIKit

internal class CollectionViewDelegateManager<Layout: ListLayout>:
    NSObject,
    CollectionViewLayoutDelegate {

    internal weak var collectionViewDelegate: UICollectionViewDelegate?

    internal let stateManager: CollectionViewStateManager<Layout>

    internal init(
        collectionViewDelegate: UICollectionViewDelegate? = nil,
        stateManager: CollectionViewStateManager<Layout>
    ) {
        self.collectionViewDelegate = collectionViewDelegate
        self.stateManager = stateManager
    }

    internal override func responds(to aSelector: Selector?) -> Bool {
        super.responds(to: aSelector) || collectionViewDelegate?.responds(to: aSelector) == true
    }

    internal override func forwardingTarget(for aSelector: Selector?) -> Any? {
        if collectionViewDelegate?.responds(to: aSelector) == true {
            return collectionViewDelegate
        }

        return super.forwardingTarget(for: aSelector)
    }

    // MARK: - CollectionViewLayoutDelegate

    internal func collectionViewLayoutContext(
        _ collectionViewLayout: UICollectionViewLayout
    ) -> ComponentContext? {
        stateManager.state.context
    }

    internal func collectionViewLayout(
        _ collectionViewLayout: UICollectionViewLayout,
        metricsForSectionAt index: Int
    ) -> Any? {
        stateManager
            .state
            .sections[safe: index]?
            .metrics
    }

    internal func collectionViewLayout(
        _ collectionViewLayout: UICollectionViewLayout,
        hasHeaderAt index: Int
    ) -> Bool {
        stateManager.state.header(at: index) != nil
    }

    internal func collectionViewLayout(
        _ collectionViewLayout: UICollectionViewLayout,
        hasFooterAt index: Int
    ) -> Bool {
        stateManager.state.footer(at: index) != nil
    }

    internal func collectionViewLayout(
        _ collectionViewLayout: UICollectionViewLayout,
        sizingForItemAt indexPath: IndexPath,
        fitting size: CGSize
    ) -> ComponentSizing? {
        guard let context = stateManager.itemContext(at: indexPath) else {
            return nil
        }

        return stateManager
            .state
            .item(at: indexPath)?
            .sizing(fitting: size, context: context)
    }

    internal func collectionViewLayout(
        _ collectionViewLayout: UICollectionViewLayout,
        sizingForHeaderAt index: Int,
        fitting size: CGSize
    ) -> ComponentSizing? {
        guard let context = stateManager.headerContext(at: IndexPath(section: index)) else {
            return nil
        }

        return stateManager
            .state
            .sections[safe: index]?
            .header?
            .sizing(fitting: size, context: context)
    }

    internal func collectionViewLayout(
        _ collectionViewLayout: UICollectionViewLayout,
        sizingForFooterAt index: Int,
        fitting size: CGSize
    ) -> ComponentSizing? {
        guard let context = stateManager.footerContext(at: IndexPath(section: index)) else {
            return nil
        }

        return stateManager
            .state
            .sections[safe: index]?
            .footer?
            .sizing(fitting: size, context: context)
    }

    // MARK: - UICollectionViewDelegate

    internal func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        collectionViewDelegate?.collectionView?(
            collectionView,
            willDisplay: cell,
            forItemAt: indexPath
        )

        if let cell = cell as? AnyListCell {
            cell.onAppear()
        }
    }

    internal func collectionView(
        _ collectionView: UICollectionView,
        willDisplaySupplementaryView view: UICollectionReusableView,
        forElementKind elementKind: String,
        at indexPath: IndexPath
    ) {
        collectionViewDelegate?.collectionView?(
            collectionView,
            willDisplaySupplementaryView: view,
            forElementKind: elementKind,
            at: indexPath
        )

        if let view = view as? AnyListSupplementaryView {
            view.onAppear()
        }
    }

    internal func collectionView(
        _ collectionView: UICollectionView,
        didEndDisplaying cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        collectionViewDelegate?.collectionView?(
            collectionView,
            didEndDisplaying: cell,
            forItemAt: indexPath
        )

        if let cell = cell as? AnyListCell {
            cell.onDisappear()
        }
    }

    internal func collectionView(
        _ collectionView: UICollectionView,
        didEndDisplayingSupplementaryView view: UICollectionReusableView,
        forElementOfKind elementKind: String,
        at indexPath: IndexPath
    ) {
        collectionViewDelegate?.collectionView?(
            collectionView,
            didEndDisplayingSupplementaryView: view,
            forElementOfKind: elementKind,
            at: indexPath
        )

        if let view = view as? AnyListSupplementaryView {
            view.onDisappear()
        }
    }

    internal func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {
        collectionViewDelegate?.collectionView?(
            collectionView,
            didSelectItemAt: indexPath
        )

        if let cell = collectionView.cellForItem(at: indexPath) as? AnyListCell {
            cell.onSelect { animated in
                collectionView.deselectItem(
                    at: indexPath,
                    animated: animated
                )
            }
        }
    }

    internal func collectionView(
        _ collectionView: UICollectionView,
        didDeselectItemAt indexPath: IndexPath
    ) {
        collectionViewDelegate?.collectionView?(
            collectionView,
            didDeselectItemAt: indexPath
        )

        if let cell = collectionView.cellForItem(at: indexPath) as? AnyListCell {
            cell.onDeselect()
        }
    }

    // MARK: - UIScrollViewDelegate

    internal func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollView.contentOffset = CGPoint(
            x: floor(scrollView.contentOffset.x),
            y: floor(scrollView.contentOffset.y)
        )

        collectionViewDelegate?.scrollViewDidEndDecelerating?(scrollView)
    }
}
#endif
