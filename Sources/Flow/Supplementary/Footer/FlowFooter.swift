#if canImport(UIKit)
import Foundation

public protocol FlowFooter: Equatable {

    associatedtype View: FlowFooterView
    where View.Footer == Self
}
#endif
