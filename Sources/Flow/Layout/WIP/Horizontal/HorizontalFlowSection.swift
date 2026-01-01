#if canImport(UIKit)
import UIKit

public typealias HorizontalFlowSection = FlowSection<HorizontalFlowLayout>

extension HorizontalFlowSection {

    public func rows(_ rows: [FlowRow]?) -> Self {
        changing { $0.metrics.rows = rows }
    }

    public func alignment(_ alignment: FlowVerticalAlignment) -> Self {
        changing { $0.metrics.alignment = alignment }
    }

    public func insets(_ insets: UIEdgeInsets) -> Self {
        changing { $0.metrics.insets = insets }
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

    public func insets(all value: CGFloat = .zero) -> Self {
        insets(UIEdgeInsets(all: value))
    }

    public func estimatedWidth(_ estimatedWidth: CGFloat?) -> Self {
        changing { $0.metrics.estimatedWidth = estimatedWidth }
    }

    public func estimatedHeight(_ estimatedHeight: CGFloat?) -> Self {
        changing { $0.metrics.estimatedHeight = estimatedHeight }
    }

    public func horizontalSpacing(_ horizontalSpacing: CGFloat?) -> Self {
        changing { $0.metrics.horizontalSpacing = horizontalSpacing }
    }

    public func verticalSpacing(_ verticalSpacing: CGFloat?) -> Self {
        changing { $0.metrics.verticalSpacing = verticalSpacing }
    }

    public func pinnedViews(_ pinnedViews: FlowLayoutPinnedViews?) -> Self {
        changing { $0.metrics.pinnedViews = pinnedViews }
    }
}
#endif
