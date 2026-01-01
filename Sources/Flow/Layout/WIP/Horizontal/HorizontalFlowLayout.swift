#if canImport(UIKit)
import CoreGraphics
import Foundation

public struct HorizontalFlowLayout {

    public var metrics: HorizontalFlowMetrics
    public var appearance: FlowLayoutAppearance
    public var scrollAnchor: FlowLayoutScrollAnchor

    public init(
        metrics: HorizontalFlowMetrics = .default,
        appearance: FlowLayoutAppearance = .default,
        scrollAnchor: FlowLayoutScrollAnchor = .leading
    ) {
        self.metrics = metrics
        self.appearance = appearance
        self.scrollAnchor = scrollAnchor
    }
}

extension HorizontalFlowLayout: FlowLayout {

    public static let `default` = Self()

    public var scrollAxis: FlowLayoutScrollAxis {
        .horizontal
    }

    public func updateState(
        _ state: inout FlowLayoutState<Self>,
        context: FlowLayoutContext
    ) -> Bool {
        // TODO: реализовать по аналогии с VerticalFlowLayout
        return true
    }
}

extension HorizontalFlowLayout: Changeable {

    public func metrics(_ metrics: HorizontalFlowMetrics) -> Self {
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
