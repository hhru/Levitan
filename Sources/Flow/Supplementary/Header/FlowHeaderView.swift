#if canImport(UIKit)
import Foundation

public protocol FlowHeaderView: AnyFlowHeaderView {

    associatedtype Header: FlowHeader

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
