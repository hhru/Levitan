#if canImport(UIKit)
import Foundation

public protocol FlowFooter: Equatable, Sendable {

    associatedtype View: FlowFooterView
    where View.Footer == Self
}
#endif
