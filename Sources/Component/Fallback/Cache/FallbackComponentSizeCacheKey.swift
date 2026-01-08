#if canImport(UIKit)
import Foundation

internal struct FallbackComponentSizeCacheKey {

    internal let content: Any
    internal let containerSize: CGSize

    private let contentHashValue: AnyHashable
    private let contentEqualBox: (_ other: Any) -> Bool

    internal init<Content: Equatable>(
        content: Content,
        containerSize: CGSize
    ) {
        self.content = content
        self.containerSize = containerSize

        contentHashValue = ObjectIdentifier(Content.self)

        contentEqualBox = { other in
            content == other as? Content
        }
    }
}

extension FallbackComponentSizeCacheKey: Equatable {

    internal static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.contentEqualBox(rhs.content) && lhs.containerSize == rhs.containerSize
    }
}

extension FallbackComponentSizeCacheKey: Hashable {

    internal func hash(into hasher: inout Hasher) {
        hasher.combine(contentHashValue)
        hasher.combine(containerSize)
    }
}
#endif
