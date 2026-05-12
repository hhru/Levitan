import Foundation

extension Equatable {

    internal func isEqual(to other: any Equatable) -> Bool {
        guard let other = other as? Self else {
            return false
        }

        return self == other
    }
}
