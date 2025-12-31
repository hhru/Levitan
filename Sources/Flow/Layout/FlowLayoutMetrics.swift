#if canImport(UIKit)
import Foundation

public protocol FlowLayoutMetrics: Equatable, Sendable {

    static var `default`: Self { get }
}
#endif
