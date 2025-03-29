#if canImport(UIKit)
import CoreFoundation
import Foundation

public final class FallbackComponentSizeCache {

    private var sizes: [FallbackComponentSizeCacheKey: FallbackComponentBodySize] = [:]

    public init() { }

    internal func resetSize<Content: Equatable>(for content: Content) {
        sizes = sizes.filter { key, _ in
            content == key.content as? Content
        }
    }

    internal func restoreSize<Content: Equatable>(
        for content: Content,
        fitting fittingSize: CGSize
    ) -> FallbackComponentBodySize? {
        let key = FallbackComponentSizeCacheKey(
            content: content,
            fittingSize: fittingSize
        )

        return sizes[key]
    }

    internal func storeSize<Content: Equatable>(
        _ size: FallbackComponentBodySize,
        for content: Content,
        fitting fittingSize: CGSize
    ) {
        let key = FallbackComponentSizeCacheKey(
            content: content,
            fittingSize: fittingSize
        )

        sizes[key] = size
    }

    internal func resolveSize<Content: Equatable>(
        for content: Content,
        fitting fittingSize: CGSize,
        using closure: () -> FallbackComponentBodySize
    ) -> FallbackComponentBodySize {
        let cacheSize = restoreSize(
            for: content,
            fitting: fittingSize
        )

        if let size = cacheSize {
            return size
        }

        let size = closure()

        storeSize(
            size,
            for: content,
            fitting: fittingSize
        )

        return size
    }
}
#endif
