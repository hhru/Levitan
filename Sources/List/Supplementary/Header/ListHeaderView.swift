#if canImport(UIKit)
import Foundation

public protocol ListHeaderView: AnyListHeaderView {

    associatedtype Header: ListHeader

    static func sizing(
        for header: Header,
        fitting size: CGSize,
        context: ComponentContext
    ) -> ComponentSizing

    func update(
        with header: Header,
        context: ComponentContext
    )
}
#endif
