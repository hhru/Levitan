import Foundation

internal protocol DiffableSection: Diffable {

    associatedtype Item: Diffable

    var items: [Item] { get }

    func items(_ items: [Item]) -> Self
}
