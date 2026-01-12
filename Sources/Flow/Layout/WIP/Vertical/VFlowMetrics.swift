#if canImport(UIKit)
import UIKit

public struct VFlowMetrics {

    public var columns: [FlowColumn]?
    public var alignment: FlowHorizontalAlignment

    public var insets: UIEdgeInsets

    public var estimatedWidth: CGFloat?
    public var estimatedHeight: CGFloat?

    public var horizontalSpacing: CGFloat?
    public var verticalSpacing: CGFloat?

    public var pinnedViews: FlowLayoutPinnedViews?

    public init(
        columns: [FlowColumn]? = nil,
        alignment: FlowHorizontalAlignment = .center,
        insets: UIEdgeInsets = .zero,
        estimatedWidth: CGFloat? = nil,
        estimatedHeight: CGFloat? = nil,
        horizontalSpacing: CGFloat? = nil,
        verticalSpacing: CGFloat? = nil,
        pinnedViews: FlowLayoutPinnedViews? = nil
    ) {
        self.columns = columns
        self.alignment = alignment

        self.insets = insets

        self.estimatedWidth = estimatedWidth
        self.estimatedHeight = estimatedHeight

        self.horizontalSpacing = horizontalSpacing
        self.verticalSpacing = verticalSpacing

        self.pinnedViews = pinnedViews
    }
}

extension VFlowMetrics: FlowLayoutMetrics {

    public static let `default` = Self()
}

extension VFlowMetrics: Changeable {

    public func columns(_ columns: [FlowColumn]?) -> Self {
        changing { $0.columns = columns }
    }

    public func alignment(_ alignment: FlowHorizontalAlignment) -> Self {
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
