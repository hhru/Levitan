#if canImport(UIKit)
import UIKit

public typealias HFlow = Flow<HFlowLayout>

extension HFlow {

    public func metrics(_ metrics: HFlowMetrics) -> Self {
        changing { $0.layout.metrics = metrics }
    }

    public func appearance(_ appearance: FlowLayoutAppearance) -> Self {
        changing { $0.layout.appearance = appearance }
    }

    public func scrollAnchor(_ scrollAnchor: FlowLayoutScrollAnchor) -> Self {
        changing { $0.layout.scrollAnchor = scrollAnchor }
    }

    public func rows(_ rows: [FlowRow]?) -> Self {
        changing { $0.layout.metrics.rows = rows }
    }

    public func alignment(_ alignment: FlowVerticalAlignment) -> Self {
        changing { $0.layout.metrics.alignment = alignment }
    }

    public func insets(_ insets: UIEdgeInsets) -> Self {
        changing { $0.layout.metrics.insets = insets }
    }

    public func insets(
        top: CGFloat = .zero,
        leading: CGFloat = .zero,
        bottom: CGFloat = .zero,
        trailing: CGFloat = .zero
    ) -> Self {
        insets(
            UIEdgeInsets(
                top: top,
                left: leading,
                bottom: bottom,
                right: trailing
            )
        )
    }

    public func insets(_ length: CGFloat = .zero) -> Self {
        insets(UIEdgeInsets(all: length))
    }

    public func estimatedWidth(_ estimatedWidth: CGFloat?) -> Self {
        changing { $0.layout.metrics.estimatedWidth = estimatedWidth }
    }

    public func estimatedHeight(_ estimatedHeight: CGFloat?) -> Self {
        changing { $0.layout.metrics.estimatedHeight = estimatedHeight }
    }

    public func horizontalSpacing(_ horizontalSpacing: CGFloat?) -> Self {
        changing { $0.layout.metrics.horizontalSpacing = horizontalSpacing }
    }

    public func verticalSpacing(_ verticalSpacing: CGFloat?) -> Self {
        changing { $0.layout.metrics.verticalSpacing = verticalSpacing }
    }

    public func pinnedViews(_ pinnedViews: FlowLayoutPinnedViews?) -> Self {
        changing { $0.layout.metrics.pinnedViews = pinnedViews }
    }
}
#endif
