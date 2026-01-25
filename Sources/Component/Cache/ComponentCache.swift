#if canImport(UIKit)
import CoreGraphics
import Foundation

/// Кэш для компонентов.
///
/// Используется для хранения размеров компонентов с более "умным" механизмом их переиспользования.
///
/// - SeeAlso: ``Component``
/// - SeeAlso: ``FallbackComponent``
public final class ComponentCache {

    private var sizes: [ComponentCacheSizeKey: Set<ComponentCacheSize>] = [:]

    /// Создает кэш для компонентов.
    public init() { }
}

extension ComponentCache {

    internal func resetSize<Content: Equatable>(for content: Content) {
        sizes.removeValue(forKey: ComponentCacheSizeKey(content: content))
    }

    internal func restoreSize<Content: Equatable>(
        for content: Content,
        proposedSize: CGSize,
        boundingSize: CGSize
    ) -> CGSize? {
        let key = ComponentCacheSizeKey(content: content)

        guard let sizes = sizes[key] else {
            return nil
        }

        for size in sizes {
            let targetSize = resolveTargetSize(
                sizing: size.contentSizing,
                proposedSize: proposedSize,
                boundingSize: boundingSize
            )

            if let size = size.contentSize(fitting: targetSize) {
                return size
            }
        }

        return nil
    }

    internal func storeSize<Content: Equatable>(
        for content: Content,
        size: CGSize,
        sizing: ComponentSizing,
        proposedSize: CGSize,
        boundingSize: CGSize
    ) {
        let key = ComponentCacheSizeKey(content: content)

        let targetSize = resolveTargetSize(
            sizing: sizing,
            proposedSize: proposedSize,
            boundingSize: boundingSize
        )

        let size = ComponentCacheSize(
            targetSize: targetSize,
            contentSize: size,
            contentSizing: sizing
        )

        var sizes = self.sizes[key] ?? []

        sizes.insert(size)

        self.sizes[key] = sizes
    }
}

extension ComponentCache {

    private func resolveTargetSize(
        sizing: ComponentSizing,
        proposedSize: CGSize,
        boundingSize: CGSize
    ) -> CGSize {
        switch (sizing.width, sizing.height) {
        case (.fixed, .fixed):
            boundingSize

        case (.fixed, _):
            CGSize(
                width: boundingSize.width,
                height: proposedSize.height
            )

        case (_, .fixed):
            CGSize(
                width: proposedSize.width,
                height: boundingSize.height
            )

        default:
            proposedSize
        }
    }
}
#endif
