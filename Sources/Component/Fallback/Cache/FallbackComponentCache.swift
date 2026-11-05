#if canImport(UIKit)
import CoreGraphics
import Foundation

@MainActor
public final class FallbackComponentCache {

    private var sizes: [FallbackComponentCacheKey: Set<FallbackComponentCacheSize>] = [:]

    public nonisolated init() { }

    public func reset() {
        sizes.removeAll(keepingCapacity: true)
    }
}

extension FallbackComponentCache {

    internal func restoreSize<Content: Equatable>(
        for content: Content,
        proposedWidth: CGFloat?,
        proposedHeight: CGFloat?
    ) -> CGSize? {
        let key = FallbackComponentCacheKey(content: content)

        guard let sizes = sizes[key] else {
            return nil
        }

        for size in sizes {
            let contentSize = resolveContentSize(
                size: size,
                proposedWidth: proposedWidth,
                proposedHeight: proposedHeight
            )

            if let contentSize {
                return contentSize
            }
        }

        return nil
    }

    internal func storeSize<Content: Equatable>(
        for content: Content,
        size: CGSize,
        sizing: ComponentSizing,
        proposedWidth: CGFloat?,
        proposedHeight: CGFloat?
    ) {
        let key = FallbackComponentCacheKey(content: content)

        let targetSize = resolveTargetSize(
            sizing: sizing,
            proposedWidth: proposedWidth,
            proposedHeight: proposedHeight
        )

        let reuseSize = CGSize(
            width: min(targetSize.width, size.width),
            height: min(targetSize.height, size.height)
        )

        let size = FallbackComponentCacheSize(
            contentSize: size,
            contentSizing: sizing,
            targetSize: targetSize,
            reuseSize: reuseSize
        )

        var sizes = self.sizes[key] ?? []

        sizes.insert(size)

        self.sizes[key] = sizes
    }

    internal func resetSize<Content: Equatable>(for content: Content) {
        sizes.removeValue(forKey: FallbackComponentCacheKey(content: content))
    }
}

extension FallbackComponentCache {

    private func resolveContentSize(
        size: FallbackComponentCacheSize,
        proposedWidth: CGFloat?,
        proposedHeight: CGFloat?
    ) -> CGSize? {
        let targetSize = resolveTargetSize(
            sizing: size.contentSizing,
            proposedWidth: proposedWidth,
            proposedHeight: proposedHeight
        )

        let canReuseWidth = size.contentSizing.width.isFixed
            || (size.targetSize.width.isNormal && targetSize.width.isNormal)
            || (size.targetSize.width == targetSize.width)

        let canReuseHeight = size.contentSizing.height.isFixed
            || (size.targetSize.height.isNormal && targetSize.height.isNormal)
            || (size.targetSize.height == targetSize.height)

        guard canReuseWidth, canReuseHeight else {
            return nil
        }

        guard targetSize.contains(size.reuseSize) else {
            return nil
        }

        if size.targetSize.contains(targetSize) {
            return size.contentSize
        }

        if size.contentSize.contains(targetSize) {
            return size.contentSize
        }

        return nil
    }

    private func resolveTargetSize(
        sizing: ComponentSizing,
        proposedWidth: CGFloat?,
        proposedHeight: CGFloat?
    ) -> CGSize {
        CGSize(
            width: resolveTargetSize(
                sizingStrategy: sizing.width,
                proposedSize: proposedWidth
            ),
            height: resolveTargetSize(
                sizingStrategy: sizing.height,
                proposedSize: proposedHeight
            )
        )
    }

    private func resolveTargetSize(
        sizingStrategy: ComponentSizingStrategy,
        proposedSize: CGFloat?
    ) -> CGFloat {
        switch sizingStrategy {
        case .fixed:
            proposedSize ?? .infinity

        case .hug, .fill:
            proposedSize ?? .zero
        }
    }
}
#endif
