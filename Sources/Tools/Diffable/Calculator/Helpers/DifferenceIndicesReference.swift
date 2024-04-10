import Foundation

internal final class DifferenceIndicesReference {

    internal var indices: ContiguousArray<Int>
    internal var position = 0

    internal init(_ indices: ContiguousArray<Int>) {
        self.indices = indices
    }

    internal func push(_ index: Int) {
        indices.append(index)
    }

    internal func next() -> Int? {
        guard position < indices.endIndex else {
            return nil
        }

        defer { position += 1 }

        return indices[position]
    }
}
