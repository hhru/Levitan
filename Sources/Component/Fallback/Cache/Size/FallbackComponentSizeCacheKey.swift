#if canImport(UIKit)
import Foundation

internal struct FallbackComponentSizeCacheKey {

    internal let content: Any
    internal let fittingSize: CGSize

    private let contentHashValue: AnyHashable
    private let contentEqualBox: (_ other: Any) -> Bool

    internal init<Content: Equatable>(
        content: Content,
        fittingSize: CGSize
    ) {
        self.content = content
        self.fittingSize = fittingSize

        contentHashValue = ObjectIdentifier(Content.self)

        contentEqualBox = { other in
            content == other as? Content
        }
    }
}

extension FallbackComponentSizeCacheKey: Equatable {

    internal static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.contentEqualBox(rhs.content) && lhs.fittingSize == rhs.fittingSize
    }
}

extension FallbackComponentSizeCacheKey: Hashable {

    internal func hash(into hasher: inout Hasher) {
        hasher.combine(contentHashValue)
        hasher.combine(fittingSize)
    }
}
#endif
