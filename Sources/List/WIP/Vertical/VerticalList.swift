import UIKit

public typealias VerticalList = List<VerticalListLayout>

extension VerticalList {

    public func metrics(_ metrics: VerticalListMetrics) -> Self {
        changing { $0.layout.metrics = metrics }
    }

    public func appearance(_ appearance: ListLayoutAppearance) -> Self {
        changing { $0.layout.appearance = appearance }
    }

    public func scrollAnchor(_ scrollAnchor: ListLayoutScrollAnchor) -> Self {
        changing { $0.layout.scrollAnchor = scrollAnchor }
    }

    public func columns(_ columns: [ListColumn]?) -> Self {
        changing { $0.layout.metrics.columns = columns }
    }

    public func alignment(_ alignment: ListHorizontalAlignment) -> Self {
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

    public func insets(all value: CGFloat = .zero) -> Self {
        insets(UIEdgeInsets(all: value))
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

    public func pinnedViews(_ pinnedViews: ListLayoutPinnedViews?) -> Self {
        changing { $0.layout.metrics.pinnedViews = pinnedViews }
    }
}
