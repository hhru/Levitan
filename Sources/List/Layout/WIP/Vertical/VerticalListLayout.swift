#if canImport(UIKit)
import CoreGraphics
import Foundation

public struct VerticalListLayout {

    public var metrics: VerticalListMetrics
    public var appearance: ListLayoutAppearance
    public var scrollAnchor: ListLayoutScrollAnchor

    public init(
        metrics: VerticalListMetrics = .default,
        appearance: ListLayoutAppearance = .default,
        scrollAnchor: ListLayoutScrollAnchor = .top
    ) {
        self.metrics = metrics
        self.appearance = appearance
        self.scrollAnchor = scrollAnchor
    }

    private func resolveHeaderSize(
        at index: Int,
        fitting containerSize: CGSize,
        context: ListLayoutContext,
        metrics: VerticalListMetrics
    ) -> ListLayoutSize {
        let estimatedSize = CGSize(
            width: metrics.estimatedWidth ?? containerSize.width,
            height: metrics.estimatedHeight ?? 40.0
        )

        return context.headerSize(
            at: index,
            proposedSize: containerSize,
            estimatedSize: estimatedSize
        )
    }

    private func resolveFooterSize(
        at index: Int,
        fitting containerSize: CGSize,
        context: ListLayoutContext,
        metrics: VerticalListMetrics
    ) -> ListLayoutSize {
        let estimatedSize = CGSize(
            width: metrics.estimatedWidth ?? containerSize.width,
            height: metrics.estimatedHeight ?? 40.0
        )

        return context.footerSize(
            at: index,
            proposedSize: containerSize,
            estimatedSize: estimatedSize
        )
    }

    private func resolveItemSize(
        at indexPath: IndexPath,
        fitting containerSize: CGSize,
        updating previousSize: CGSize?,
        context: ListLayoutContext,
        metrics: VerticalListMetrics
    ) -> ListLayoutSize {
        let estimatedSize = CGSize(
            width: previousSize?.width
                ?? metrics.estimatedWidth
                ?? containerSize.width,
            height: previousSize?.height
                ?? metrics.estimatedHeight
                ?? 120.0
        )

        return context.itemSize(
            at: indexPath,
            proposedSize: containerSize,
            estimatedSize: estimatedSize
        )
    }

    private func updateHeader(
        _ header: inout ListLayoutHeader,
        size: ListLayoutSize?,
        metrics: VerticalListMetrics,
        minOrigin: CGFloat,
        maxOrigin: CGFloat
    ) {
        header.size = size

        if metrics.pinnedViews?.contains(.header) ?? false {
            let height = size?.value.height ?? .zero
            let maxOrigin = maxOrigin - height

            header.origin = .pinned { bounds in
                let origin = min(
                    max(bounds.minY, minOrigin),
                    maxOrigin
                )

                return CGPoint(x: .zero, y: origin)
            }

            header.zIndex = .max
        } else {
            header.origin = .normal(x: .zero, y: minOrigin)
            header.zIndex = .zero
        }
    }

    private func updateFooter(
        _ footer: inout ListLayoutFooter,
        size: ListLayoutSize?,
        metrics: VerticalListMetrics,
        minOrigin: CGFloat,
        maxOrigin: CGFloat
    ) {
        footer.size = size

        let height = size?.value.height ?? .zero
        let maxOrigin = maxOrigin - height

        if metrics.pinnedViews?.contains(.footer) ?? false {
            footer.origin = .pinned { bounds in
                let origin = min(
                    max(bounds.maxY - height, minOrigin),
                    maxOrigin
                )

                return CGPoint(x: .zero, y: origin)
            }

            footer.zIndex = .max
        } else {
            footer.origin = .normal(x: .zero, y: maxOrigin)
            footer.zIndex = .zero
        }
    }

    private func updateItems(
        of section: inout ListLayoutSection<Self>,
        at sectionIndex: Int,
        offset: CGFloat,
        fitting containerSize: CGSize,
        context: ListLayoutContext,
        metrics: VerticalListMetrics
    ) -> CGFloat {
        let containerSize = containerSize.inset(by: metrics.insets)
        var offset = offset

        for itemIndex in section.items.indices {
            let size = section.items[itemIndex].size ?? resolveItemSize(
                at: IndexPath(item: itemIndex, section: sectionIndex),
                fitting: containerSize,
                updating: section.items[itemIndex].previousSize,
                context: context,
                metrics: metrics
            )

            section.updateItem(at: itemIndex) { item in
                item.size = size

                // TODO: располагать с учетом метрик секции
                item.origin = CGPoint(
                    x: .zero,
                    y: offset
                )

                item.zIndex = itemIndex
            }

            offset += size.value.height
        }

        return offset
    }

    private func updateSection(
        _ section: inout ListLayoutSection<Self>,
        at sectionIndex: Int,
        fitting containerSize: CGSize,
        context: ListLayoutContext,
        metrics: VerticalListMetrics
    ) {
        guard section.size == nil else {
            return
        }

        var sectionSize = CGSize(
            width: containerSize.width,
            height: .zero
        )

        let headerSize = section.header.map { header in
            header.size ?? resolveHeaderSize(
                at: sectionIndex,
                fitting: containerSize,
                context: context,
                metrics: metrics
            )
        }

        let footerSize = section.footer.map { footer in
            footer.size ?? resolveFooterSize(
                at: sectionIndex,
                fitting: containerSize,
                context: context,
                metrics: metrics
            )
        }

        let headerMinOrigin = sectionSize.height

        sectionSize.height += headerSize?.value.height ?? .zero
        sectionSize.height += metrics.insets.top

        let footerMinOrigin = sectionSize.height

        sectionSize.height = updateItems(
            of: &section,
            at: sectionIndex,
            offset: sectionSize.height,
            fitting: containerSize,
            context: context,
            metrics: metrics
        )

        let headerMaxOrigin = sectionSize.height

        sectionSize.height += metrics.insets.bottom
        sectionSize.height += footerSize?.value.height ?? .zero

        let footerMaxOrigin = sectionSize.height

        section.updateHeader { header in
            updateHeader(
                &header,
                size: headerSize,
                metrics: metrics,
                minOrigin: headerMinOrigin,
                maxOrigin: headerMaxOrigin
            )
        }

        section.updateFooter { footer in
            updateFooter(
                &footer,
                size: footerSize,
                metrics: metrics,
                minOrigin: footerMinOrigin,
                maxOrigin: footerMaxOrigin
            )
        }

        section.size = sectionSize
    }
}

extension VerticalListLayout: ListLayout {

    public static let `default` = Self()

    public var scrollAxis: ListLayoutScrollAxis {
        .vertical
    }

    public func verticalScrollAnchorItem(
        state: ListLayoutState<Self>,
        contentBounds: CGRect,
        visibleItems: [IndexPath: CGRect]
    ) -> IndexPath? {
        let scrollPosition = CGPoint(
            x: contentBounds.minX + contentBounds.width * scrollAnchor.y,
            y: contentBounds.minY + contentBounds.height * scrollAnchor.y
        )

        let contentSize = state.size ?? .zero

        let contentPosition = CGPoint(
            x: contentSize.width * scrollAnchor.y,
            y: contentSize.height * scrollAnchor.y
        )

        var anchorDistance = scrollPosition.squaredDistance(to: contentPosition)

        guard anchorDistance > .leastNonzeroMagnitude else {
            return nil
        }

        var anchorItemPath: IndexPath?

        for (itemIndexPath, itemFrame) in visibleItems {
            let itemPosition = CGPoint(
                x: itemFrame.minX + itemFrame.width * scrollAnchor.y,
                y: itemFrame.minY + itemFrame.height * scrollAnchor.y
            )

            let itemDistance = scrollPosition.squaredDistance(to: itemPosition)

            if anchorDistance > itemDistance {
                anchorDistance = itemDistance
                anchorItemPath = itemIndexPath
            }
        }

        return anchorItemPath
    }

    public func updateState(
        _ state: inout ListLayoutState<Self>,
        context: ListLayoutContext
    ) -> Bool {
        guard state.origin == nil || state.size == nil else {
            return false
        }

        let containerSize = context
            .containerSize
            .inset(by: metrics.insets)

        var contentSize = CGSize(
            width: containerSize.width,
            height: metrics.insets.top
        )

        for sectionIndex in state.sections.indices {
            state.updateSection(at: sectionIndex) { section in
                let sectionMetrics = VerticalListMetrics(
                    columns: section.metrics?.columns ?? metrics.columns,
                    alignment: section.metrics?.alignment ?? metrics.alignment,
                    insets: section.metrics?.insets ?? .zero,
                    estimatedHeight: section.metrics?.estimatedHeight ?? metrics.estimatedHeight,
                    horizontalSpacing: section.metrics?.horizontalSpacing ?? metrics.horizontalSpacing,
                    verticalSpacing: section.metrics?.verticalSpacing ?? metrics.verticalSpacing,
                    pinnedViews: section.metrics?.pinnedViews ?? metrics.pinnedViews
                )

                updateSection(
                    &section,
                    at: sectionIndex,
                    fitting: containerSize,
                    context: context,
                    metrics: sectionMetrics
                )

                section.origin = CGPoint(
                    x: metrics.insets.left,
                    y: contentSize.height
                )

                contentSize.height += section.size?.height ?? .zero
            }
        }

        contentSize.height += metrics.insets.bottom

        state.size = contentSize
        state.origin = .zero // TODO: располагать с учетом anchor

        return true
    }
}

extension VerticalListLayout: Changeable {

    public func appearance(_ appearance: ListLayoutAppearance) -> Self {
        changing { $0.appearance = appearance }
    }

    public func metrics(_ metrics: VerticalListMetrics) -> Self {
        changing { $0.metrics = metrics }
    }

    public func scrollAnchor(_ scrollAnchor: ListLayoutScrollAnchor) -> Self {
        changing { $0.scrollAnchor = scrollAnchor }
    }
}
#endif
