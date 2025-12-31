#if canImport(UIKit)
import Foundation

public protocol FlowCell: AnyFlowCell {

    associatedtype Item: FlowItem

    static func sizing(
        for item: Item,
        fitting size: CGSize,
        context: ComponentContext
    ) -> ComponentSizing

    func update(
        with item: Item,
        context: ComponentContext
    )
}
#endif
