import UIKit

extension UICollectionView {

    private func performChangeset<Section: DiffableSection>(
        _ changeset: DifferenceChangeset<Section>,
        updateSections: ([Section]) -> Void,
        updateCells: (_ indexPaths: [IndexPath]) -> Void,
        completion: (() -> Void)? = nil
    ) {
        let updates = {
            updateSections(changeset.sections)

            if !changeset.sectionDeleted.isEmpty {
                self.deleteSections(IndexSet(changeset.sectionDeleted))
            }

            if !changeset.sectionInserted.isEmpty {
                self.insertSections(IndexSet(changeset.sectionInserted))
            }

            if !changeset.sectionUpdated.isEmpty {
                self.reloadSections(IndexSet(changeset.sectionUpdated))
            }

            changeset.sectionMoved.forEach { motion in
                self.moveSection(motion.source, toSection: motion.target)
            }

            if !changeset.itemDeleted.isEmpty {
                self.deleteItems(at: changeset.itemDeleted.map { $0.indexPath })
            }

            if !changeset.itemInserted.isEmpty {
                self.insertItems(at: changeset.itemInserted.map { $0.indexPath })
            }

            if !changeset.itemUpdated.isEmpty {
                updateCells(changeset.itemUpdated.map { $0.indexPath })
            }

            changeset.itemMoved.forEach { motion in
                self.moveItem(
                    at: motion.source.indexPath,
                    to: motion.target.indexPath
                )
            }
        }

        performBatchUpdates(updates) { _ in
            DispatchQueue.main.async { completion?() }
        }
    }

    internal func updateData<Section: DiffableSection>(
        using changesets: [DifferenceChangeset<Section>],
        shouldInterrupt: ((DifferenceChangeset<Section>) -> Bool)? = nil,
        updateSections: ([Section]) -> Void,
        updateCells: (_ indexPaths: [IndexPath]) -> Void,
        completion: (() -> Void)? = nil
    ) {
        guard let lastChangeset = changesets.last else {
            completion?()
            return
        }

        guard window != nil else {
            return reloadData(
                using: lastChangeset,
                updateSections: updateSections,
                completion: completion
            )
        }

        for i in 0..<changesets.count {
            let changeset = changesets[i]

            guard shouldInterrupt?(changeset) != true else {
                return reloadData(
                    using: lastChangeset,
                    updateSections: updateSections,
                    completion: completion
                )
            }

            let completion = (i < changesets.count - 1)
                ? nil
                : completion

            performChangeset(
                changeset,
                updateSections: updateSections,
                updateCells: updateCells,
                completion: completion
            )
        }
    }

    internal func reloadData<Section: DiffableSection>(
        using changeset: DifferenceChangeset<Section>,
        updateSections: ([Section]) -> Void,
        completion: (() -> Void)? = nil
    ) {
        updateSections(changeset.sections)
        reloadData { completion?() }
    }
}
