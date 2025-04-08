#if canImport(UIKit)
import Foundation

public protocol ListLayout: Equatable {

    associatedtype Metrics: ListLayoutMetrics

    static var `default`: Self { get }

    var metrics: Metrics { get }
    var appearance: ListLayoutAppearance { get }

    var scrollAxis: ListLayoutScrollAxis { get }
    var scrollAnchor: ListLayoutScrollAnchor { get }

    func horizontalScrollAnchorItem(
        state: ListLayoutState<Self>,
        contentBounds: CGRect,
        visibleItems: [IndexPath: CGRect]
    ) -> IndexPath?

    func verticalScrollAnchorItem(
        state: ListLayoutState<Self>,
        contentBounds: CGRect,
        visibleItems: [IndexPath: CGRect]
    ) -> IndexPath?

    func updateState(
        _ state: inout ListLayoutState<Self>,
        context: ListLayoutContext
    ) -> Bool
}

extension ListLayout {

    public func horizontalScrollAnchorItem(
        state: ListLayoutState<Self>,
        contentBounds: CGRect,
        visibleItems: [IndexPath: CGRect]
    ) -> IndexPath? {
        nil
    }

    public func verticalScrollAnchorItem(
        state: ListLayoutState<Self>,
        contentBounds: CGRect,
        visibleItems: [IndexPath: CGRect]
    ) -> IndexPath? {
        nil
    }
}
#endif
