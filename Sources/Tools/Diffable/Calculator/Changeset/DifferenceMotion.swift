import Foundation

internal struct DifferenceMotion<Path: Hashable>: Hashable {

    internal let source: Path
    internal let target: Path
}
