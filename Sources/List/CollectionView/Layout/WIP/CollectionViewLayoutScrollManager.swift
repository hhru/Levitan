#if canImport(UIKit)
import UIKit

internal final class CollectionViewLayoutScrollManager<Layout: ListLayout> {

    internal weak var collectionView: UICollectionView?

    internal let updateManager: CollectionViewLayoutUpdateManager<Layout>

    private var scrollSnapshot: CollectionViewLayoutScrollSnapshot<Layout>?

    internal init(updateManager: CollectionViewLayoutUpdateManager<Layout>) {
        self.updateManager = updateManager
    }
}

extension CollectionViewLayoutScrollManager {

    internal func preservePosition(state: ListLayoutState<Layout>?, layout: Layout) {
        guard scrollSnapshot == nil else {
            return
        }

        let contentBounds = collectionView?.contentBounds ?? .zero

        if let state, let collectionView {
            let visibleItems = collectionView
                .indexPathsForVisibleItems
                .reduce(into: [:]) { items, itemIndexPath in
                    items[itemIndexPath] = state
                        .item(at: itemIndexPath)?
                        .frame
                }

            scrollSnapshot = CollectionViewLayoutScrollSnapshot(
                contentBounds: contentBounds,
                visibleItems: visibleItems,
                state: state,
                layout: layout
            )
        } else {
            scrollSnapshot = CollectionViewLayoutScrollSnapshot(
                contentBounds: contentBounds,
                layout: layout
            )
        }
    }

    internal func restorePosition(
        state: ListLayoutState<Layout>?,
        layout: Layout,
        finally: Bool = true
    ) -> CGPoint {
        let scrollSnapshot = scrollSnapshot

        if finally {
            self.scrollSnapshot = nil
        }

        guard let collectionView else {
            return .zero
        }

        guard let state, let scrollSnapshot else {
            return collectionView.contentOffset
        }

        let position = scrollSnapshot.restorePosition(
            state: state,
            layout: layout,
            contentBounds: collectionView.contentBounds
        )

        return CGPoint(
            x: position.x - collectionView.adjustedContentInset.left,
            y: position.y - collectionView.adjustedContentInset.top
        )
    }

    internal func preparePositionForUpdates(
        currentState: ListLayoutState<Layout>?,
        previousState: ListLayoutState<Layout>?
    ) {
        guard var scrollSnapshot else {
            return
        }

        guard let currentState, let previousState else {
            return reset()
        }

        scrollSnapshot.updateDeletingItems(
            at: updateManager.itemsToDelete,
            currentState: currentState,
            previousState: previousState
        )

        scrollSnapshot.updateDeletingSections(
            at: updateManager.sectionsToDelete,
            currentState: currentState,
            previousState: previousState
        )

        scrollSnapshot.updateInsertingSections(updateManager.sectionsToInsert)
        scrollSnapshot.updateInsertingItems(updateManager.itemsToInsert)

        self.scrollSnapshot = scrollSnapshot
    }

    internal func reset() {
        scrollSnapshot = nil
    }
}
#endif
