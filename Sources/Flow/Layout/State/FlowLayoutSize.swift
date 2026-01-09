#if canImport(UIKit)
import CoreGraphics
import Foundation

public enum FlowLayoutSize: Equatable, Sendable {

    case actual(_ value: CGSize)

    case estimated(
        _ value: CGSize,
        sizing: ComponentSizing,
        containerSize: CGSize,
        boundingSize: CGSize
    )

    public var value: CGSize {
        switch self {
        case let .actual(value):
            value

        case let .estimated(value, _, _, _):
            value
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
}

extension FlowLayoutSize {

    internal var sizing: CollectionViewLayoutSizing? {
        switch self {
        case .actual:
            nil

        case let .estimated(_, sizing, containerSize, boundingSize):
            CollectionViewLayoutSizing(
                width: sizing.width,
                height: sizing.height,
                containerSize: containerSize,
                boundingSize: boundingSize
            )
        }
    }

    internal var containerSize: CGSize {
        switch self {
        case let .actual(size):
            size

        case let .estimated(_, _, containerSize, _):
            containerSize
        }
    }

    internal init(
        estimatedSize: CGSize,
        sizing: ComponentSizing,
        containerSize: CGSize,
        boundingSize: CGSize
    ) {
        switch (sizing.width, sizing.height) {
        case let (.fixed(width), .fixed(height)):
            self = .actual(CGSize(width: width, height: height))

        default:
            self = .estimated(
                estimatedSize,
                sizing: sizing,
                containerSize: containerSize,
                boundingSize: boundingSize
            )
        }
    }
}
#endif
