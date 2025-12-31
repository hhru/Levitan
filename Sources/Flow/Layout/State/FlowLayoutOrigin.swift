#if canImport(UIKit)
import CoreGraphics
import Foundation

public enum FlowLayoutOrigin {

    case normal(_ origin: CGPoint)
    case pinned(_ origin: (_ bounds: CGRect) -> CGPoint)

    internal var isPinned: Bool {
        switch self {
        case .pinned:
            true

        case .normal:
            false
        }
    }
}

extension FlowLayoutOrigin {

    public static func normal(x: CGFloat, y: CGFloat) -> Self {
        .normal(CGPoint(x: x, y: y))
    }
}
#endif
