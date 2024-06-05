import Foundation

internal struct DifferenceChangeset<Section: DiffableSection> {

    internal let sections: [Section]

    internal let sectionDeleted: [Int]
    internal let sectionInserted: [Int]
    internal let sectionUpdated: [Int]
    internal let sectionMoved: [DifferenceMotion<Int>]

    internal let itemDeleted: [ItemPath]
    internal let itemInserted: [ItemPath]
    internal let itemUpdated: [ItemPath]
    internal let itemMoved: [DifferenceMotion<ItemPath>]

    internal init(
        sections: [Section],
        sectionDeleted: [Int] = [],
        sectionInserted: [Int] = [],
        sectionUpdated: [Int] = [],
        sectionMoved: [DifferenceMotion<Int>] = [],
        itemDeleted: [ItemPath] = [],
        itemInserted: [ItemPath] = [],
        itemUpdated: [ItemPath] = [],
        itemMoved: [DifferenceMotion<ItemPath>] = []
    ) {
        self.sections = sections
        self.sectionDeleted = sectionDeleted
        self.sectionInserted = sectionInserted
        self.sectionUpdated = sectionUpdated
        self.sectionMoved = sectionMoved
        self.itemDeleted = itemDeleted
        self.itemInserted = itemInserted
        self.itemUpdated = itemUpdated
        self.itemMoved = itemMoved
    }
}
