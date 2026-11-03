#if canImport(UIKit)
import Foundation

public final class TextCache: @unchecked Sendable {

    private var layouts: [TextCacheKey: TextLayout]
    private let layoutsLock = NSLock()

    public init() {
        layouts = [:]
    }

    public func reset() {
        layoutsLock.withLock {
            self.layouts.removeAll(keepingCapacity: true)
        }
    }
}

extension TextCache {

    internal func restoreLayout(for key: TextCacheKey) -> TextLayout? {
        layoutsLock.withLock {
            layouts[key]
        }
    }

    internal func storeLayout(_ layout: TextLayout, for key: TextCacheKey) {
        layoutsLock.withLock {
            self.layouts[key] = layout
        }
    }
}
#endif
