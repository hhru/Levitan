import Foundation

internal struct SectionDifferenceChangeset {

    internal let deleted: [Int]
    internal let inserted: [Int]
    internal let updated: [Int]
    internal let moved: [DifferenceMotion<Int>]

    internal let sourceTraces: ContiguousArray<DifferenceTrace<Int>>
    internal let targetReferences: ContiguousArray<Int?>
}
