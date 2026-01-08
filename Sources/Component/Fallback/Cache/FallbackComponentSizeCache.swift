#if canImport(UIKit)
import CoreFoundation
import Foundation

public final class FallbackComponentSizeCache {

    private var sizes: [FallbackComponentSizeCacheKey: FallbackComponentBodySize] = [:]

    public init() { }

    internal func resetSize<Content: Equatable>(for content: Content) {
        sizes = sizes.filter { key, _ in
            content != key.content as? Content
        }
    }

    internal func restoreSize<Content: Equatable>(
        for content: Content,
        fitting containerSize: CGSize
    ) -> FallbackComponentBodySize? {
        let key = FallbackComponentSizeCacheKey(
            content: content,
            containerSize: containerSize
        )

        return sizes[key]
    }

    internal func storeSize<Content: Equatable>(
        _ size: FallbackComponentBodySize,
        for content: Content,
        fitting containerSize: CGSize
    ) {
        let key = FallbackComponentSizeCacheKey(
            content: content,
            containerSize: containerSize
        )

        sizes[key] = size
    }
}
#endif
