import CoreGraphics

public enum ListColumnSize: Equatable {

    case fixed(_ size: CGFloat)

    case flexible(
        minimum: CGFloat,
        maximum: CGFloat = .infinity
    )
}

extension ListColumnSize {

    public static let flexible = Self.flexible(minimum: 10)
}
