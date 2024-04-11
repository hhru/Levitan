import UIKit

internal final class CollectionViewLayoutScrollManager<Layout: ListLayout> {

    internal weak var collectionView: UICollectionView?

    internal let updateManager: CollectionViewLayoutUpdateManager<Layout>

    private var horizontalAnchor = CollectionViewLayoutScrollAnchor.horizontal
    private var verticalAnchor = CollectionViewLayoutScrollAnchor.vertical

    internal init(updateManager: CollectionViewLayoutUpdateManager<Layout>) {
        self.updateManager = updateManager
    }

    private func preserveHorizontalPosition(
        state: ListLayoutState<Layout>,
        layout: Layout,
        contentBounds: CGRect,
        visibleItems: [IndexPath]
    ) {
        let position = contentBounds.minX + contentBounds.width * layout.scrollAnchor.x

        let itemIndexPath = layout.horizontalScrollAnchorItem(
            state: state,
            contentBounds: contentBounds,
            visibleItems: visibleItems
        )

        horizontalAnchor.preservePosition(
            position,
            itemIndexPath: itemIndexPath,
            state: state,
            anchor: layout.scrollAnchor.x
        )
    }

    private func preserveVerticalPosition(
        state: ListLayoutState<Layout>,
        layout: Layout,
        contentBounds: CGRect,
        visibleItems: [IndexPath]
    ) {
        let position = contentBounds.minY + contentBounds.height * layout.scrollAnchor.y

        let itemIndexPath = layout.verticalScrollAnchorItem(
            state: state,
            contentBounds: contentBounds,
            visibleItems: visibleItems
        )

        verticalAnchor.preservePosition(
            position,
            itemIndexPath: itemIndexPath,
            state: state,
            anchor: layout.scrollAnchor.y
        )
    }

    private func restoreHorizontalPosition(
        state: ListLayoutState<Layout>,
        layout: Layout,
        contentBounds: CGRect
    ) -> CGFloat {
        let position = horizontalAnchor.restorePosition(
            state: state,
            anchor: layout.scrollAnchor.x
        )

        return max(position - contentBounds.width * layout.scrollAnchor.x, .zero)
    }

    private func restoreVerticalPosition(
        state: ListLayoutState<Layout>,
        layout: Layout,
        contentBounds: CGRect
    ) -> CGFloat {
        let position = verticalAnchor.restorePosition(
            state: state,
            anchor: layout.scrollAnchor.y
        )

        return max(position - contentBounds.height * layout.scrollAnchor.y, .zero)
    }

    private func updateHorizontalPosition(
        currentState: ListLayoutState<Layout>,
        previousState: ListLayoutState<Layout>
    ) {
        horizontalAnchor.updateDeletingItems(
            at: updateManager.itemsToDelete,
            currentState: currentState,
            previousState: previousState
        )

        horizontalAnchor.updateDeletingSections(
            at: updateManager.sectionsToDelete,
            currentState: currentState,
            previousState: previousState
        )

        horizontalAnchor.updateInsertingSections(updateManager.sectionsToInsert)
        horizontalAnchor.updateInsertingItems(updateManager.itemsToInsert)
    }

    private func updateVerticalPosition(
        currentState: ListLayoutState<Layout>,
        previousState: ListLayoutState<Layout>
    ) {
        verticalAnchor.updateDeletingItems(
            at: updateManager.itemsToDelete,
            currentState: currentState,
            previousState: previousState
        )

        verticalAnchor.updateDeletingSections(
            at: updateManager.sectionsToDelete,
            currentState: currentState,
            previousState: previousState
        )

        verticalAnchor.updateInsertingSections(updateManager.sectionsToInsert)
        verticalAnchor.updateInsertingItems(updateManager.itemsToInsert)
    }
}

extension CollectionViewLayoutScrollManager {

    internal func preservePosition(state: ListLayoutState<Layout>?, layout: Layout) {
        guard let collectionView, let state else {
            return
        }

        let contentBounds = collectionView.contentBounds
        let visibleItems = collectionView.indexPathsForVisibleItems

        preserveHorizontalPosition(
            state: state,
            layout: layout,
            contentBounds: contentBounds,
            visibleItems: visibleItems
        )

        preserveVerticalPosition(
            state: state,
            layout: layout,
            contentBounds: contentBounds,
            visibleItems: visibleItems
        )
    }

    internal func restorePosition(state: ListLayoutState<Layout>?, layout: Layout) -> CGPoint {
        guard let collectionView else {
            return .zero
        }

        guard let state else {
            return collectionView.contentOffset
        }

        let contentBounds = collectionView.contentBounds

        let horizontalPosition = restoreHorizontalPosition(
            state: state,
            layout: layout,
            contentBounds: contentBounds
        )

        let verticalPosition = restoreVerticalPosition(
            state: state,
            layout: layout,
            contentBounds: contentBounds
        )

        return CGPoint(
            x: horizontalPosition - collectionView.adjustedContentInset.left,
            y: verticalPosition - collectionView.adjustedContentInset.top
        )
    }

    internal func preparePositionForUpdates(
        currentState: ListLayoutState<Layout>?,
        previousState: ListLayoutState<Layout>?
    ) {
        guard let currentState, let previousState else {
            return reset()
        }

        updateHorizontalPosition(
            currentState: currentState,
            previousState: previousState
        )

        updateVerticalPosition(
            currentState: currentState,
            previousState: previousState
        )
    }

    internal func reset() {
        horizontalAnchor.reset()
        verticalAnchor.reset()
    }
}
