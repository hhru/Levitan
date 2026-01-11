#if canImport(UIKit)
import Foundation

public final class TextCache: @unchecked Sendable {

    private var layouts: [TextCacheKey: TextLayout]
    private let layoutsQueue: DispatchQueue

    public init() {
        layouts = [:]

        layoutsQueue = DispatchQueue(
            label: "\(Self.self)",
            qos: .userInitiated,
            attributes: .concurrent
        )
    }

    internal func restoreLayout(for key: TextCacheKey) -> TextLayout? {
        layoutsQueue.sync {
            layouts[key]
        }
    }

    internal func storeLayout(_ layout: TextLayout, for key: TextCacheKey) {
        nonisolated(unsafe) let layout = layout

        layoutsQueue.async(flags: .barrier) {
            self.layouts[key] = layout
        }
    }
}
#endif
