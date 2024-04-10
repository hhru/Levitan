import Foundation

internal struct ItemDifferenceChangeset {

    internal let deleted: [ItemPath]
    internal let inserted: [ItemPath]
    internal let updated: [ItemPath]
    internal let moved: [DifferenceMotion<ItemPath>]
}
