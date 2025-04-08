#if canImport(UIKit)
import Foundation

public struct ListLayoutPinnedViews: OptionSet {

    public let rawValue: UInt

    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
}

extension ListLayoutPinnedViews {

    public static let header = Self(rawValue: 1 << 0)
    public static let footer = Self(rawValue: 1 << 1)
}
#endif
