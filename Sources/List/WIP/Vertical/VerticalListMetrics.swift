import UIKit

public struct VerticalListMetrics {

    public let columns: [ListColumn]?
    public let alignment: ListHorizontalAlignment

    public let insets: UIEdgeInsets

    public let estimatedHeight: CGFloat?
    public let horizontalSpacing: CGFloat?
    public let verticalSpacing: CGFloat?

    public let pinnedViews: ListLayoutPinnedViews?

    public init(
        columns: [ListColumn]? = nil,
        alignment: ListHorizontalAlignment = .center,
        insets: UIEdgeInsets = .zero,
        estimatedHeight: CGFloat? = nil,
        horizontalSpacing: CGFloat? = nil,
        verticalSpacing: CGFloat? = nil,
        pinnedViews: ListLayoutPinnedViews? = nil
    ) {
        self.columns = columns
        self.alignment = alignment

        self.insets = insets

        self.estimatedHeight = estimatedHeight
        self.horizontalSpacing = horizontalSpacing
        self.verticalSpacing = verticalSpacing

        self.pinnedViews = pinnedViews
    }
}

extension VerticalListMetrics: ListLayoutMetrics {

    public static let `default` = Self()
}

extension VerticalListMetrics: Changeable {

    internal init(copy: ChangeableWrapper<Self>) {
        self.init(
            columns: copy.columns,
            alignment: copy.alignment,
            insets: copy.insets,
            estimatedHeight: copy.estimatedHeight,
            horizontalSpacing: copy.horizontalSpacing,
            verticalSpacing: copy.verticalSpacing,
            pinnedViews: copy.pinnedViews
        )
    }

    public func columns(_ columns: [ListColumn]?) -> Self {
        changing { $0.columns = columns }
    }

    public func alignment(_ alignment: ListHorizontalAlignment) -> Self {
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

    public func estimatedHeight(_ estimatedHeight: CGFloat?) -> Self {
        changing { $0.estimatedHeight = estimatedHeight }
    }

    public func horizontalSpacing(_ horizontalSpacing: CGFloat?) -> Self {
        changing { $0.horizontalSpacing = horizontalSpacing }
    }

    public func verticalSpacing(_ verticalSpacing: CGFloat?) -> Self {
        changing { $0.verticalSpacing = verticalSpacing }
    }

    public func pinnedViews(_ pinnedViews: ListLayoutPinnedViews?) -> Self {
        changing { $0.pinnedViews = pinnedViews }
    }
}
