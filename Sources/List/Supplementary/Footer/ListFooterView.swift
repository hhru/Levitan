#if canImport(UIKit)
import Foundation

public protocol ListFooterView: AnyListFooterView {

    associatedtype Footer: ListFooter

    static func sizing(
        for footer: Footer,
        fitting size: CGSize,
        context: ComponentContext
    ) -> ComponentSizing

    func update(
        with footer: Footer,
        context: ComponentContext
    )
}
#endif
