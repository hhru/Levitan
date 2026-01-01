#if canImport(UIKit)
import UIKit

public struct HorizontalFlowMetrics {

    public var rows: [FlowRow]?
    public var alignment: FlowVerticalAlignment

    public var insets: UIEdgeInsets

    public var estimatedWidth: CGFloat?
    public var estimatedHeight: CGFloat?

    public var horizontalSpacing: CGFloat?
    public var verticalSpacing: CGFloat?

    public var pinnedViews: FlowLayoutPinnedViews?

    public init(
        rows: [FlowRow]? = nil,
        alignment: FlowVerticalAlignment = .center,
        insets: UIEdgeInsets = .zero,
        estimatedWidth: CGFloat? = nil,
        estimatedHeight: CGFloat? = nil,
        horizontalSpacing: CGFloat? = nil,
        verticalSpacing: CGFloat? = nil,
        pinnedViews: FlowLayoutPinnedViews? = nil
    ) {
        self.rows = rows
        self.alignment = alignment

        self.insets = insets

        self.estimatedWidth = estimatedWidth
        self.estimatedHeight = estimatedHeight

        self.horizontalSpacing = horizontalSpacing
        self.verticalSpacing = verticalSpacing

        self.pinnedViews = pinnedViews
    }
}

extension HorizontalFlowMetrics: FlowLayoutMetrics {

    public static let `default` = Self()
}

extension HorizontalFlowMetrics: Changeable {

    public func rows(_ rows: [FlowRow]?) -> Self {
        changing { $0.rows = rows }
    }

    public func alignment(_ alignment: FlowVerticalAlignment) -> Self {
        changing { $0.alignment = alignment }
    }

    public func insets(_ insets: UIEdgeInsets) -> Self {
        changing { $0.insets = insets }
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
        changing { $0.estimatedWidth = estimatedWidth }
    }

    public func estimatedHeight(_ estimatedHeight: CGFloat?) -> Self {
        changing { $0.estimatedHeight = estimatedHeight }
    }

    public func horizontalSpacing(_ horizontalSpacing: CGFloat?) -> Self {
        changing { $0.horizontalSpacing = horizontalSpacing }
    }

    public func verticalSpacing(_ verticalSpacing: CGFloat?) -> Self {
        changing { $0.verticalSpacing = verticalSpacing }
    }

    public func pinnedViews(_ pinnedViews: FlowLayoutPinnedViews?) -> Self {
        changing { $0.pinnedViews = pinnedViews }
    }
}
#endif
