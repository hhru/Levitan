import Foundation

internal enum DifferenceOccurrence {

    case unique(index: Int)
    case duplicate(reference: DifferenceIndicesReference)
}
