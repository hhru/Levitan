#if canImport(UIKit)
import UIKit

public struct FontScaleValue: TokenValue, Sendable {

    public let textStyle: UIFont.TextStyle
    public let maxPointSize: CGFloat?

    public init(
        textStyle: UIFont.TextStyle,
        maxPointSize: CGFloat? = nil
    ) {
        self.textStyle = textStyle
        self.maxPointSize = maxPointSize
    }
}
#endif
