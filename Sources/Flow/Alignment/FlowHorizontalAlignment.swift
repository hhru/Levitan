#if canImport(UIKit)
import CoreGraphics
import Foundation

public struct FlowHorizontalAlignment: Equatable, Sendable {

    private let value: CGFloat

    private init(_ value: CGFloat) {
        self.value = value
    }
}

extension FlowHorizontalAlignment {

    public static let leading = Self(.zero)
    public static let center = Self(0.5)
    public static let trailing = Self(1.0)
}
#endif
