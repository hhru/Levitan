#if canImport(UIKit)
import CoreGraphics
import Foundation

public struct FlowVerticalAlignment: Equatable, Sendable {

    private let value: CGFloat

    private init(_ value: CGFloat) {
        self.value = value
    }
}

extension FlowVerticalAlignment {

    public static let top = Self(.zero)
    public static let center = Self(0.5)
    public static let bottom = Self(1.0)
}
#endif
