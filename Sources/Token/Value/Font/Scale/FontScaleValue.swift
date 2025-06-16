#if canImport(UIKit)
import UIKit

public struct FontScaleValue:
    TokenValue,
    Changeable,
    Sendable {

    public var textStyle: UIFont.TextStyle
    public var maxPointSize: CGFloat?

    public init(
        textStyle: UIFont.TextStyle,
        maxPointSize: CGFloat? = nil
    ) {
        self.textStyle = textStyle
        self.maxPointSize = maxPointSize
    }
}
#endif
