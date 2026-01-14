#if canImport(UIKit)
import CoreGraphics
import Foundation

public protocol FlowItem: Identifiable, Equatable, Sendable {

    associatedtype Cell: FlowCell
    where Cell.Item == Self

    typealias Deselection = Cell.Deselection

    var id: ComponentID { get }
}
#endif
