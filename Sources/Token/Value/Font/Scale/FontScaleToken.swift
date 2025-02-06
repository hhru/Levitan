#if canImport(UIKit1)
import UIKit

public typealias FontScaleToken = Token<FontScaleValue>

extension FontScaleToken {

    public init(
        textStyle: UIFont.TextStyle,
        maxPointSize: CGFloat? = nil
    ) {
        self = Value(
            textStyle: textStyle,
            maxPointSize: maxPointSize
        ).token
    }
}
#endif
