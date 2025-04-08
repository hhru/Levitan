#if canImport(UIKit)
import CoreGraphics
import Foundation

public protocol ListItem: AnyListItem, Equatable {

    associatedtype Cell: ListCell
    where Cell.Item == Self

    typealias Deselection = Cell.Deselection
}

extension ListItem {

    public var sectionItem: ListSectionItem {
        ListSectionItem(wrapped: self)
    }
}
#endif
