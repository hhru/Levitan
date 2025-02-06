#if canImport(UIKit)
import Foundation

public struct TextPartState {

    public let isHovered: Bool
    public let isPressed: Bool
}

extension TextPartState {

    public static let `default` = Self(
        isHovered: false,
        isPressed: false
    )
}
#endif
