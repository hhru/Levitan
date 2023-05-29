import Foundation

extension RangeReplaceableCollection {

    internal mutating func prepend<T: Collection>(contentsOf collection: T) where Self.Element == T.Element {
        insert(contentsOf: collection, at: startIndex)
    }

    internal mutating func prepend(_ element: Element) {
        insert(element, at: startIndex)
    }

    internal func prepending<T: Collection>(contentsOf collection: T) -> Self where Self.Element == T.Element {
        collection + self
    }

    internal func prepending(_ element: Element) -> Self {
        prepending(contentsOf: [element])
    }

    internal func appending<T: Collection>(
        contentsOf collection: T
    ) -> Self where Self.Element == T.Element {
        self + collection
    }

    internal func appending(_ element: Element) -> Self {
        appending(contentsOf: [element])
    }

    public func inserting(_ element: Element, at index: Index) -> Self {
        var collection = self
        collection.insert(element, at: index)

        return collection
    }

    public func removing(at index: Index) -> Self {
        var collection = self
        collection.remove(at: index)

        return collection
    }

    internal func removingAll(where predicate: (Element) throws -> Bool) rethrows -> Self {
        var collection = self
        try collection.removeAll(where: predicate)

        return collection
    }
}
