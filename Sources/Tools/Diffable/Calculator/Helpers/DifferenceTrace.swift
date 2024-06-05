import Foundation

internal struct DifferenceTrace<Index> {

    internal var reference: Index?
    internal var deleteOffset = 0
    internal var isTracked = false
}
