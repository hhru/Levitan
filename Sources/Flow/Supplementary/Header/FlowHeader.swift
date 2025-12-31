#if canImport(UIKit)
import Foundation

public protocol FlowHeader: Equatable, Sendable {

    associatedtype View: FlowHeaderView
    where View.Header == Self
}
#endif
