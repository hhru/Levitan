#if canImport(UIKit)
import CoreGraphics
import Foundation

public struct HFlowLayout {

    public var metrics: HFlowMetrics
    public var appearance: FlowLayoutAppearance
    public var scrollAnchor: FlowLayoutScrollAnchor

    public init(
        metrics: HFlowMetrics = .default,
        appearance: FlowLayoutAppearance = .default,
        scrollAnchor: FlowLayoutScrollAnchor = .leading
    ) {
        self.metrics = metrics
        self.appearance = appearance
        self.scrollAnchor = scrollAnchor
    }
}

extension HFlowLayout: FlowLayout {

    public static let `default` = Self()

    public var scrollAxis: FlowLayoutScrollAxis {
        .horizontal
    }

    public func updateState(
        _ state: inout FlowLayoutState<Self>,
        context: FlowLayoutContext
    ) -> Bool {
        // TODO: реализовать по аналогии с VFlowLayout
        true
    }
}

extension HFlowLayout: Changeable {

    public func metrics(_ metrics: HFlowMetrics) -> Self {
        changing { $0.metrics = metrics }
    }

    public func appearance(_ appearance: FlowLayoutAppearance) -> Self {
        changing { $0.appearance = appearance }
    }

    public func scrollAnchor(_ scrollAnchor: FlowLayoutScrollAnchor) -> Self {
        changing { $0.scrollAnchor = scrollAnchor }
    }
}
#endif
