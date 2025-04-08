#if canImport(UIKit)
import UIKit

internal final class CollectionViewLayoutUpdateManager<Layout: ListLayout> {

    internal weak var collectionView: UICollectionView?

    internal private(set) var sectionsToReload: [Int: ListLayoutSection<Layout>] = [:]
    internal private(set) var sectionsToDelete: [Int] = []
    internal private(set) var sectionsToInsert: [(Int, ListLayoutSection<Layout>)] = []

    internal private(set) var itemsToReload: [IndexPath: ListLayoutItem] = [:]
    internal private(set) var itemsToDelete: [IndexPath] = []
    internal private(set) var itemsToInsert: [(IndexPath, ListLayoutItem)] = []

    private var deletedSections: Set<Int> = []
    private var insertedSections: [Int: ListLayoutSection<Layout>] = [:]

    private var deletedItems: Set<IndexPath> = []
    private var insertedItems: [IndexPath: ListLayoutItem] = [:]

    private var delegate: CollectionViewLayoutDelegate? {
        collectionView?.delegate as? CollectionViewLayoutDelegate
    }

    private func makeSectionForReloading(at index: Int, state: ListLayoutState<Layout>) -> ListLayoutSection<Layout> {
        guard let previousSection = state.section(at: index) else {
            return makeSectionForInserting(at: index)
        }

        guard let collectionView else {
            return ListLayoutSection(items: [])
        }

        let collectionViewLayout = collectionView.collectionViewLayout
        let itemCount = collectionView.numberOfItems(inSection: index)

        let previousItems = Array(previousSection.items.prefix(itemCount))

        let newItems = Array(
            repeating: ListLayoutItem(),
            count: itemCount - previousItems.count
        )

        let items = previousItems.appending(contentsOf: newItems)

        let header = delegate?.collectionViewLayout(collectionViewLayout, hasHeaderAt: index) == true
            ? ListLayoutHeader(frame: previousSection.header?.frame)
            : nil

        let footer = delegate?.collectionViewLayout(collectionViewLayout, hasFooterAt: index) == true
            ? ListLayoutFooter(frame: previousSection.footer?.frame)
            : nil

        let metrics = delegate?
            .collectionViewLayout(collectionViewLayout, metricsForSectionAt: index)
            .flatMap { $0 as? Layout.Metrics }

        return ListLayoutSection(
            index: index,
            frame: previousSection.frame,
            items: items,
            header: header,
            footer: footer,
            metrics: metrics
        )
    }

    private func makeSectionForInserting(at index: Int) -> ListLayoutSection<Layout> {
        guard let collectionView else {
            return ListLayoutSection(items: [])
        }

        let collectionViewLayout = collectionView.collectionViewLayout
        let itemCount = collectionView.numberOfItems(inSection: index)

        let items = Array(
            repeating: ListLayoutItem(),
            count: itemCount
        )

        let header = delegate?.collectionViewLayout(collectionViewLayout, hasHeaderAt: index) == true
            ? ListLayoutHeader()
            : nil

        let footer = delegate?.collectionViewLayout(collectionViewLayout, hasFooterAt: index) == true
            ? ListLayoutFooter()
            : nil

        let metrics = delegate?
            .collectionViewLayout(collectionViewLayout, metricsForSectionAt: index)
            .flatMap { $0 as? Layout.Metrics }

        return ListLayoutSection(
            items: items,
            header: header,
            footer: footer,
            metrics: metrics
        )
    }

    private func handleReloadAction(of update: UICollectionViewUpdateItem, state: ListLayoutState<Layout>) {
        guard let indexPath = update.indexPathBeforeUpdate else {
            fatalError("`indexPathBeforeUpdate` cannot be `nil` for a `reload` action")
        }

        if indexPath.item == NSNotFound {
            sectionsToReload[indexPath.section] = makeSectionForReloading(
                at: indexPath.section,
                state: state
            )
        } else {
            itemsToReload[indexPath] = ListLayoutItem(
                indexPath: indexPath,
                frame: state.item(at: indexPath)?.frame
            )
        }
    }

    private func handleDeleteAction(of update: UICollectionViewUpdateItem) {
        guard let indexPath = update.indexPathBeforeUpdate else {
            fatalError("`indexPathBeforeUpdate` cannot be `nil` for a `delete` action")
        }

        if indexPath.item == NSNotFound {
            deletedSections.insert(indexPath.section)
        } else {
            deletedItems.insert(indexPath)
        }
    }

    private func handleInsertAction(of update: UICollectionViewUpdateItem) {
        guard let indexPath = update.indexPathAfterUpdate else {
            fatalError("`indexPathAfterUpdate` cannot be `nil` for an `insert` action")
        }

        if indexPath.item == NSNotFound {
            insertedSections[indexPath.section] = makeSectionForInserting(at: indexPath.section)
        } else {
            insertedItems[indexPath] = ListLayoutItem()
        }
    }

    private func handleMoveAction(of update: UICollectionViewUpdateItem, state: ListLayoutState<Layout>) {
        guard let indexPath = update.indexPathBeforeUpdate else {
            fatalError("`indexPathBeforeUpdate` cannot be `nil` for a `move` action")
        }

        if indexPath.item == NSNotFound {
            deletedSections.insert(indexPath.section)
        } else {
            deletedItems.insert(indexPath)
        }

        guard let newIndexPath = update.indexPathAfterUpdate else {
            fatalError("`indexPathAfterUpdate` cannot be `nil` for a `move` action")
        }

        if newIndexPath.item == NSNotFound {
            insertedSections[newIndexPath.section] = state.section(at: newIndexPath.section)
        } else {
            insertedItems[newIndexPath] = state.item(at: newIndexPath)
        }
    }

    private func handleUpdateAction(of update: UICollectionViewUpdateItem, state: ListLayoutState<Layout>) {
        switch update.updateAction {
        case .reload:
            handleReloadAction(of: update, state: state)

        case .delete:
            handleDeleteAction(of: update)

        case .insert:
            handleInsertAction(of: update)

        case .move:
            handleMoveAction(of: update, state: state)

        case .none:
            break

        @unknown default:
            break
        }

        sectionsToDelete = deletedSections.sorted(by: >)
        sectionsToInsert = insertedSections.sorted { $0.key < $1.key }

        itemsToDelete = deletedItems.sorted(by: >)
        itemsToInsert = insertedItems.sorted { $0.key < $1.key }
    }
}

extension CollectionViewLayoutUpdateManager {

    internal func isSectionDeletedOrMoved(at index: Int) -> Bool {
        deletedSections.contains(index)
    }

    internal func isSectionInserted(at index: Int) -> Bool {
        insertedSections[index].map { $0.index == nil } ?? false
    }

    internal func isItemDeletedOrMoved(at indexPath: IndexPath) -> Bool {
        if isSectionDeletedOrMoved(at: indexPath.section) {
            return true
        }

        return deletedItems.contains(indexPath)
    }

    internal func isItemInserted(at indexPath: IndexPath) -> Bool {
        if isSectionInserted(at: indexPath.section) {
            return true
        }

        return insertedItems[indexPath].map { $0.indexPath == nil } ?? false
    }

    internal func applyUpdates(_ updates: [UICollectionViewUpdateItem], state: ListLayoutState<Layout>?) {
        reset()

        guard let state else {
            return
        }

        for update in updates {
            handleUpdateAction(of: update, state: state)
        }
    }

    internal func reset() {
        sectionsToInsert.removeAll(keepingCapacity: true)
        sectionsToDelete.removeAll(keepingCapacity: true)
        sectionsToReload.removeAll(keepingCapacity: true)

        itemsToInsert.removeAll(keepingCapacity: true)
        itemsToDelete.removeAll(keepingCapacity: true)
        itemsToReload.removeAll(keepingCapacity: true)

        deletedSections.removeAll(keepingCapacity: true)
        insertedSections.removeAll(keepingCapacity: true)

        deletedItems.removeAll(keepingCapacity: true)
        insertedItems.removeAll(keepingCapacity: true)
    }
}
#endif
