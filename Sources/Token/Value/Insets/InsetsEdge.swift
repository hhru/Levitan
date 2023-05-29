import Foundation

public struct InsetsEdge: OptionSet, Sendable {

    public let rawValue: UInt

    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
}

extension InsetsEdge {

    public static let top = Self(rawValue: 1 << 0)
    public static let leading = Self(rawValue: 1 << 1)
    public static let bottom = Self(rawValue: 1 << 2)
    public static let trailing = Self(rawValue: 1 << 3)

    public static let vertical: Self = [.top, .bottom]
    public static let horizontal: Self = [.leading, .trailing]
    public static let all: Self = [.top, .leading, .bottom, .trailing]
}
