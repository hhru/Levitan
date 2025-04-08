#if canImport(UIKit)
import CoreGraphics
import Foundation

public enum ListLayoutOrigin {

    case normal(_ origin: CGPoint)
    case pinned(_ origin: (_ bounds: CGRect) -> CGPoint)

    internal var isPinned: Bool {
        switch self {
        case .pinned:
            return true

        case .normal:
            return false
        }
    }
}

extension ListLayoutOrigin {

    public static func normal(x: CGFloat, y: CGFloat) -> Self {
        .normal(CGPoint(x: x, y: y))
    }
}
#endif
