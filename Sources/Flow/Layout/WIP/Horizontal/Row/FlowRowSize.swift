#if canImport(UIKit)
import Foundation

public enum FlowRowSize: Equatable, Sendable {

    case fixed(_ size: CGFloat)

    case flexible(
        minimum: CGFloat,
        maximum: CGFloat = .infinity
    )
}

extension FlowRowSize {

    public static let flexible = Self.flexible(minimum: 10)
}
#endif
