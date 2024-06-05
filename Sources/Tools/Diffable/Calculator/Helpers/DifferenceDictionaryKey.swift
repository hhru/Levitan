import Foundation

internal struct DifferenceDictionaryKey {

    internal let pointeeHashValue: Int
    internal let pointer: UnsafePointer<AnyHashable>

    internal init(pointer: UnsafePointer<AnyHashable>) {
        self.pointeeHashValue = pointer.pointee.hashValue
        self.pointer = pointer
    }
}

extension DifferenceDictionaryKey: Equatable {

    internal static func == (lhs: Self, rhs: Self) -> Bool {
        if lhs.pointeeHashValue != rhs.pointeeHashValue {
            return false
        }

        if lhs.pointer.distance(to: rhs.pointer) == 0 {
            return true
        }

        if lhs.pointer.pointee == rhs.pointer.pointee {
            return true
        }

        return false
    }
}

extension DifferenceDictionaryKey: Hashable {

    internal func hash(into hasher: inout Hasher) {
        hasher.combine(pointeeHashValue)
    }
}
