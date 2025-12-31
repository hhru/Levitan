#if canImport(UIKit)
import Foundation

public protocol FlowLayout: Equatable, Sendable {

    associatedtype Metrics: FlowLayoutMetrics

    static var `default`: Self { get }

    var metrics: Metrics { get }
    var appearance: FlowLayoutAppearance { get }

    var scrollAxis: FlowLayoutScrollAxis { get }
    var scrollAnchor: FlowLayoutScrollAnchor { get }

    @MainActor
    func horizontalScrollAnchorItem(
        state: FlowLayoutState<Self>,
        contentBounds: CGRect,
        visibleItems: [IndexPath: CGRect]
    ) -> IndexPath?

    @MainActor
    func verticalScrollAnchorItem(
        state: FlowLayoutState<Self>,
        contentBounds: CGRect,
        visibleItems: [IndexPath: CGRect]
    ) -> IndexPath?

    @MainActor
    func updateState(
        _ state: inout FlowLayoutState<Self>,
        context: FlowLayoutContext
    ) -> Bool
}

extension FlowLayout {

    public func horizontalScrollAnchorItem(
        state: FlowLayoutState<Self>,
        contentBounds: CGRect,
        visibleItems: [IndexPath: CGRect]
    ) -> IndexPath? {
        nil
    }

    public func verticalScrollAnchorItem(
        state: FlowLayoutState<Self>,
        contentBounds: CGRect,
        visibleItems: [IndexPath: CGRect]
    ) -> IndexPath? {
        nil
    }
}
#endif
