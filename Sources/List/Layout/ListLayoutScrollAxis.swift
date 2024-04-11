import Foundation

public struct ListLayoutScrollAxis: OptionSet {

    public let rawValue: UInt

    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
}

extension ListLayoutScrollAxis {

    public static let horizontal = Self(rawValue: 1 << 0)
    public static let vertical = Self(rawValue: 1 << 1)
}
