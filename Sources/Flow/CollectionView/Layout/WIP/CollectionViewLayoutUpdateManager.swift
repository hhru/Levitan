#if canImport(UIKit)
import UIKit

@MainActor
internal final class CollectionViewLayoutUpdateManager<Layout: FlowLayout> {

    internal weak var collectionView: UICollectionView?

    internal private(set) var sectionsToReload: [Int: FlowLayoutSection<Layout>] = [:]
    internal private(set) var sectionsToDelete: [Int] = []
    internal private(set) var sectionsToInsert: [(Int, FlowLayoutSection<Layout>)] = []

    internal private(set) var itemsToReload: [IndexPath: FlowLayoutItem] = [:]
    internal private(set) var itemsToDelete: [IndexPath] = []
    internal private(set) var itemsToInsert: [(IndexPath, FlowLayoutItem)] = []

    internal private(set) var hasUpdates = false
    internal private(set) var isUpdating = false

    private var deletedSections: Set<Int> = []
    private var insertedSections: [Int: FlowLayoutSection<Layout>] = [:]

    private var deletedItems: Set<IndexPath> = []
    private var insertedItems: [IndexPath: FlowLayoutItem] = [:]

    private var delegate: CollectionViewLayoutDelegate? {
        collectionView?.delegate as? CollectionViewLayoutDelegate
    }

    private func makeSectionForReloading(at index: Int, state: FlowLayoutState<Layout>) -> FlowLayoutSection<Layout> {
        guard let previousSection = state.section(at: index) else {
            return makeSectionForInserting(at: index)
        }

        guard let collectionView else {
            return FlowLayoutSection(items: [])
        }

        let collectionViewLayout = collectionView.collectionViewLayout
        let itemCount = collectionView.numberOfItems(inSection: index)

        let previousItems = Array(previousSection.items.prefix(itemCount))

        let newItems = Array(
            repeating: FlowLayoutItem(),
            count: itemCount - previousItems.count
        )

        let items = previousItems.appending(contentsOf: newItems)

        let header = delegate?.collectionViewLayout(collectionViewLayout, hasHeaderAt: index) == true
            ? FlowLayoutHeader(frame: previousSection.header?.frame)
            : nil

        let footer = delegate?.collectionViewLayout(collectionViewLayout, hasFooterAt: index) == true
            ? FlowLayoutFooter(frame: previousSection.footer?.frame)
            : nil

        let metrics = delegate?
            .collectionViewLayout(collectionViewLayout, metricsForSectionAt: index)
            .flatMap { $0 as? Layout.Metrics }

        return FlowLayoutSection(
            index: index,
            frame: previousSection.frame,
            items: items,
            header: header,
            footer: footer,
            metrics: metrics
        )
    }

    private func makeSectionForInserting(at index: Int) -> FlowLayoutSection<Layout> {
        guard let collectionView else {
            return FlowLayoutSection(items: [])
        }

        let collectionViewLayout = collectionView.collectionViewLayout
        let itemCount = collectionView.numberOfItems(inSection: index)

        let items = Array(
            repeating: FlowLayoutItem(),
            count: itemCount
        )

        let header = delegate?.collectionViewLayout(collectionViewLayout, hasHeaderAt: index) == true
            ? FlowLayoutHeader()
            : nil

        let footer = delegate?.collectionViewLayout(collectionViewLayout, hasFooterAt: index) == true
            ? FlowLayoutFooter()
            : nil

        let metrics = delegate?
            .collectionViewLayout(collectionViewLayout, metricsForSectionAt: index)
            .flatMap { $0 as? Layout.Metrics }

        return FlowLayoutSection(
            items: items,
            header: header,
            footer: footer,
            metrics: metrics
        )
    }

    private func handleReloadAction(of update: UICollectionViewUpdateItem, state: FlowLayoutState<Layout>) {
        guard let indexPath = update.indexPathBeforeUpdate else {
            fatalError("`indexPathBeforeUpdate` cannot be `nil` for a `reload` action")
        }

        if indexPath.item == NSNotFound {
            sectionsToReload[indexPath.section] = makeSectionForReloading(
                at: indexPath.section,
                state: state
            )
        } else {
            itemsToReload[indexPath] = FlowLayoutItem(
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
            insertedItems[indexPath] = FlowLayoutItem()
        }
    }

    private func handleMoveAction(of update: UICollectionViewUpdateItem, state: FlowLayoutState<Layout>) {
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
            insertedSections[newIndexPath.section] = state.section(at: indexPath.section)
        } else {
            insertedItems[newIndexPath] = state.item(at: indexPath)
        }
    }

    private func handleUpdateAction(of update: UICollectionViewUpdateItem, state: FlowLayoutState<Layout>) {
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

    internal func applyUpdates(_ updates: [UICollectionViewUpdateItem], state: FlowLayoutState<Layout>?) {
        reset()

        isUpdating = true

        guard let state else {
            return
        }

        for update in updates {
            handleUpdateAction(of: update, state: state)
        }

        hasUpdates = !updates.isEmpty
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

        hasUpdates = false
        isUpdating = false
    }
}
#endif
