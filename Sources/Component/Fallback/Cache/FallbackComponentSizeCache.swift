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
}
#endif
