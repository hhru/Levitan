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
        visibleItems: [IndexPath]
    ) -> IndexPath?

    func verticalScrollAnchorItem(
        state: ListLayoutState<Self>,
        contentBounds: CGRect,
        visibleItems: [IndexPath]
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
        visibleItems: [IndexPath]
    ) -> IndexPath? {
        nil
    }

    public func verticalScrollAnchorItem(
        state: ListLayoutState<Self>,
        contentBounds: CGRect,
        visibleItems: [IndexPath]
    ) -> IndexPath? {
        nil
    }
}
