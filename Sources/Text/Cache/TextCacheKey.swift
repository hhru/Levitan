#if canImport(UIKit)
import Foundation

internal struct TextCacheKey: Hashable, Sendable {

    internal let content: Text
    internal let context: TextContext

    internal let hoveredPartIndex: Int?
    internal let pressedPartIndex: Int?
}
#endif
