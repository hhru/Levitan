#if canImport(UIKit)
import Foundation

public protocol FlowFooterView: AnyFlowFooterView {

    associatedtype Footer: FlowFooter

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
