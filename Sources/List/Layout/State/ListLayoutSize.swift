#if canImport(UIKit)
import CoreGraphics
import Foundation

public enum ListLayoutSize {

    case actual(_ size: CGSize)

    case estimated(
        _ size: CGSize,
        sizing: ComponentSizing,
        proposedSize: CGSize
    )

    public var value: CGSize {
        switch self {
        case let .actual(size):
            return size

        case let .estimated(size, _, _):
            return size
        }
    }

    public var isActual: Bool {
        switch self {
        case .actual:
            true

        case .estimated:
            false
        }
    }

    public var isEstimated: Bool {
        switch self {
        case .actual:
            false

        case .estimated:
            true
        }
    }

    internal init(
        sizing: ComponentSizing,
        proposedSize: CGSize,
        estimatedSize: CGSize
    ) {
        switch (sizing.width, sizing.height) {
        case (.hug, .hug), (.fixed, .hug), (.hug, .fixed), (.hug, .fill), (.fill, .hug):
            self = .estimated(
                estimatedSize,
                sizing: sizing,
                proposedSize: proposedSize
            )

        case let (.fixed(fixedWidth), .fixed(fixedHeight)):
            self = .actual(CGSize(width: fixedWidth, height: fixedHeight))

        case let (.fixed(fixedWidth), .fill):
            self = .actual(CGSize(width: fixedWidth, height: proposedSize.height))

        case let (.fill, .fixed(fixedHeight)):
            self = .actual(CGSize(width: proposedSize.width, height: fixedHeight))

        case (.fill, .fill):
            self = .actual(proposedSize)
        }
    }
}
#endif
