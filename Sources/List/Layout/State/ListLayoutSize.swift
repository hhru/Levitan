import CoreGraphics

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
