#if canImport(UIKit)
import UIKit

internal class CollectionViewDelegateManager<Layout: FlowLayout>:
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
        let isSuperResponds = super.responds(to: aSelector)

        guard Thread.isMainThread, !isSuperResponds else {
            return isSuperResponds
        }

        return MainActor.assumeIsolated {
            collectionViewDelegate?.responds(to: aSelector) == true
        }
    }

    internal override func forwardingTarget(for aSelector: Selector?) -> Any? {
        guard Thread.isMainThread else {
            return super.forwardingTarget(for: aSelector)
        }

        let delegateTarget = MainActor.assumeIsolated {
            collectionViewDelegate?.responds(to: aSelector) == true
                ? collectionViewDelegate
                : nil
        }

        return delegateTarget ?? super.forwardingTarget(for: aSelector)
    }

    // MARK: - CollectionViewLayoutDelegate

    internal func collectionViewLayoutContext(_ collectionViewLayout: UICollectionViewLayout) -> ComponentContext? {
        stateManager.state.context
    }

    internal func collectionViewLayout(
        _ collectionViewLayout: UICollectionViewLayout,
        metricsForSectionAt index: Int
    ) -> Any? {
        stateManager.state.metrics(at: index)
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
        boundingSize: CGSize,
        containerSize: CGSize
    ) -> ComponentSizing? {
        let context = stateManager.itemContext(
            at: indexPath,
            containerSize: containerSize
        )

        guard let context else {
            return nil
        }

        return stateManager
            .state
            .item(at: indexPath)?
            .sizing(fitting: boundingSize, context: context)
    }

    internal func collectionViewLayout(
        _ collectionViewLayout: UICollectionViewLayout,
        sizingForHeaderAt index: Int,
        boundingSize: CGSize,
        containerSize: CGSize
    ) -> ComponentSizing? {
        let context = stateManager.headerContext(
            at: IndexPath(section: index),
            containerSize: containerSize
        )

        guard let context else {
            return nil
        }

        return stateManager
            .state
            .header(at: index)?
            .sizing(fitting: boundingSize, context: context)
    }

    internal func collectionViewLayout(
        _ collectionViewLayout: UICollectionViewLayout,
        sizingForFooterAt index: Int,
        boundingSize: CGSize,
        containerSize: CGSize
    ) -> ComponentSizing? {
        let context = stateManager.footerContext(
            at: IndexPath(section: index),
            containerSize: containerSize
        )

        guard let context else {
            return nil
        }

        return stateManager
            .state
            .footer(at: index)?
            .sizing(fitting: boundingSize, context: context)
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

        if let cell = cell as? AnyFlowCell {
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

        if let view = view as? AnyFlowSupplementaryView {
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

        if let cell = cell as? AnyFlowCell {
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

        if let view = view as? AnyFlowSupplementaryView {
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

        if let cell = collectionView.cellForItem(at: indexPath) as? AnyFlowCell {
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

        if let cell = collectionView.cellForItem(at: indexPath) as? AnyFlowCell {
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
