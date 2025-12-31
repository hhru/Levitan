#if canImport(UIKit)
import CoreGraphics
import Foundation

public protocol FlowItem: Equatable, Sendable {

    associatedtype Cell: FlowCell
    where Cell.Item == Self

    typealias Deselection = Cell.Deselection

    var identifier: ComponentIdentifier { get }
}
#endif
