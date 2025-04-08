#if canImport(UIKit)
import Foundation

public enum ListRowSize: Equatable {

    case fixed(_ size: CGFloat)

    case flexible(
        minimum: CGFloat,
        maximum: CGFloat = .infinity
    )
}

extension ListRowSize {

    public static let flexible = Self.flexible(minimum: 10)
}
#endif
