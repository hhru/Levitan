import Foundation

internal final class DifferenceCalculator {

    private let sectionDifferenceCalculator = SectionDifferenceCalculator()
    private let itemDifferenceCalculator = ItemDifferenceCalculator()

    internal init() { }

    private func resolveFifthChangeset<Section: DiffableSection>(
        sections: [Section],
        sectionChangeset: SectionDifferenceChangeset
    ) -> DifferenceChangeset<Section>? {
        guard !sectionChangeset.updated.isEmpty else {
            return nil
        }

        return DifferenceChangeset(
            sections: sections,
            sectionUpdated: sectionChangeset.updated
        )
    }

    private func resolveFourthChangeset<Section: DiffableSection>(
        sections: [Section],
        itemChangeset: ItemDifferenceChangeset
    ) -> DifferenceChangeset<Section>? {
        guard !itemChangeset.inserted.isEmpty || !itemChangeset.moved.isEmpty else {
            return nil
        }

        return DifferenceChangeset(
            sections: sections,
            itemInserted: itemChangeset.inserted,
            itemMoved: itemChangeset.moved
        )
    }

    private func resolveThirdChangeset<Section: DiffableSection>(
        sections: [Section],
        sectionChangeset: SectionDifferenceChangeset
    ) -> DifferenceChangeset<Section>? {
        guard !sectionChangeset.inserted.isEmpty || !sectionChangeset.moved.isEmpty else {
            return nil
        }

        return DifferenceChangeset(
            sections: sections,
            sectionInserted: sectionChangeset.inserted,
            sectionMoved: sectionChangeset.moved
        )
    }

    private func resolveSecondChangeset<Section: DiffableSection>(
        sections: [Section],
        sectionChangeset: SectionDifferenceChangeset,
        itemChangeset: ItemDifferenceChangeset
    ) -> DifferenceChangeset<Section>? {
        guard !sectionChangeset.deleted.isEmpty || !itemChangeset.deleted.isEmpty else {
            return nil
        }

        return DifferenceChangeset(
            sections: sections,
            sectionDeleted: sectionChangeset.deleted,
            itemDeleted: itemChangeset.deleted
        )
    }

    private func resolveFirstChangeset<Section: DiffableSection>(
        sections: [Section],
        itemChangeset: ItemDifferenceChangeset
    ) -> DifferenceChangeset<Section>? {
        guard !itemChangeset.updated.isEmpty else {
            return nil
        }

        return DifferenceChangeset(
            sections: sections,
            itemUpdated: itemChangeset.updated
        )
    }

    private func resolveChangesets<Section: DiffableSection>(
        targetSections: [Section],
        sectionChangeset: SectionDifferenceChangeset,
        itemChangeset: ItemDifferenceChangeset,
        stageSections: DifferenceStageSections<Section>
    ) -> [DifferenceChangeset<Section>] {
        var changesets: [DifferenceChangeset<Section>] = []

        resolveFifthChangeset(
            sections: targetSections,
            sectionChangeset: sectionChangeset
        ).map { changesets.append($0) }

        resolveFourthChangeset(
            sections: changesets.isEmpty ? targetSections : stageSections.fourthStageSections,
            itemChangeset: itemChangeset
        ).map { changesets.append($0) }

        resolveThirdChangeset(
            sections: changesets.isEmpty ? targetSections : stageSections.thirdStageSections,
            sectionChangeset: sectionChangeset
        ).map { changesets.append($0) }

        resolveSecondChangeset(
            sections: changesets.isEmpty ? targetSections : stageSections.secondStageSections,
            sectionChangeset: sectionChangeset,
            itemChangeset: itemChangeset
        ).map { changesets.append($0) }

        resolveFirstChangeset(
            sections: changesets.isEmpty ? targetSections : stageSections.firstStageSections,
            itemChangeset: itemChangeset
        ).map { changesets.append($0) }

        return changesets.reversed()
    }

    internal func calculateDifference<Section: DiffableSection>(
        sourceSections: [Section],
        targetSections: [Section]
    ) -> [DifferenceChangeset<Section>] {
        let sectionChangeset = sectionDifferenceCalculator.calculateDifference(
            from: sourceSections,
            to: targetSections
        )

        let stageSections = DifferenceStageSections(
            firstStageSections: sourceSections
        )

        let itemChangeset = itemDifferenceCalculator.calculateDifference(
            from: sourceSections,
            to: targetSections,
            sectionChangeset: sectionChangeset,
            stageSections: stageSections
        )

        return resolveChangesets(
            targetSections: targetSections,
            sectionChangeset: sectionChangeset,
            itemChangeset: itemChangeset,
            stageSections: stageSections
        )
    }

    internal func calculateDifference<Section: DiffableSection>(
        sourceSections: [Section],
        targetSections: [Section]
    ) async -> [DifferenceChangeset<Section>] {
        let task = Task.detached(priority: .userInitiated) {
            self.calculateDifference(
                sourceSections: sourceSections,
                targetSections: targetSections
            )
        }

        return await task.value
    }
}
