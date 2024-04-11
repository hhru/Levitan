import Foundation

public protocol ListCell: AnyListCell {

    associatedtype Item: ListItem

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
