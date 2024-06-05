import Foundation

extension Sequence {

    internal func count(where predicate: (Element) throws -> Bool) rethrows -> Int {
        try reduce(.zero) { count, element in
            count + (try predicate(element) ? 1 : 0)
        }
    }
}
