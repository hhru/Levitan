#if canImport(UIKit)
import Foundation

public protocol FlowHeader: Equatable {

    associatedtype View: FlowHeaderView
    where View.Header == Self
}
#endif
