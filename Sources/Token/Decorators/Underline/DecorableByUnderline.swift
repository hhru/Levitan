#if canImport(UIKit1)
import Foundation

public protocol DecorableByUnderline {

    func underline(_ underline: TypographyLineValue?) -> Self
}

extension DecorableByUnderline {

    public func underline() -> Self {
        underline(.single)
    }
}
#endif
