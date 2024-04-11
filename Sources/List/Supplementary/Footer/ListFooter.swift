import Foundation

public protocol ListFooter: AnyListFooter, Equatable {

    associatedtype View: ListFooterView
    where View.Footer == Self
}

extension ListFooter {

    public var sectionFooter: ListSectionFooter {
        ListSectionFooter(wrapped: self)
    }
}
