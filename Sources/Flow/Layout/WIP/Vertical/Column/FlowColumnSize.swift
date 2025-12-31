#if canImport(UIKit)
import CoreGraphics
import Foundation

public enum FlowColumnSize: Equatable, Sendable {

    case fixed(_ size: CGFloat)

    case flexible(
        minimum: CGFloat,
        maximum: CGFloat = .infinity
    )
}

extension FlowColumnSize {

    public static let flexible = Self.flexible(minimum: 10)
}
#endif
