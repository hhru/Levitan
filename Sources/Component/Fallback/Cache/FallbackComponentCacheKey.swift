#if canImport(UIKit)
import Foundation

internal struct FallbackComponentCacheKey {

    internal let content: Any

    private let contentHashValue: AnyHashable
    private let contentEqualBox: (_ other: Any) -> Bool

    internal init<Content: Equatable>(content: Content) {
        self.content = content

        if let content = content as? AnyHashable {
            contentHashValue = content
        } else {
            contentHashValue = ObjectIdentifier(Content.self)
        }

        contentEqualBox = { other in
            content == other as? Content
        }
    }
}

extension FallbackComponentCacheKey: Equatable {

    internal static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.contentEqualBox(rhs.content)
    }
}

extension FallbackComponentCacheKey: Hashable {

    internal func hash(into hasher: inout Hasher) {
        hasher.combine(contentHashValue)
    }
}
#endif
