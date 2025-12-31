#if canImport(UIKit)
import Foundation

public struct FlowLayoutScrollAxis: OptionSet, Sendable {

    public let rawValue: UInt

    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
}

extension FlowLayoutScrollAxis {

    public static let horizontal = Self(rawValue: 1 << 0)
    public static let vertical = Self(rawValue: 1 << 1)
}
#endif
