#if canImport(UIKit)
import CoreGraphics
import Foundation

public protocol FlowItem: Equatable {

    associatedtype Cell: FlowCell
    where Cell.Item == Self

    typealias Deselection = Cell.Deselection

    var identifier: AnyHashable { get }
}
#endif
