#if canImport(UIKit)
import Foundation

public protocol ListHeader: AnyListHeader, Equatable {

    associatedtype View: ListHeaderView
    where View.Header == Self
}

extension ListHeader {

    public var sectionHeader: ListSectionHeader {
        ListSectionHeader(wrapped: self)
    }
}
#endif
