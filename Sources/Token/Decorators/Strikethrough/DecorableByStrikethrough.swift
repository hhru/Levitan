#if canImport(UIKit1)
import Foundation

public protocol DecorableByStrikethrough {

    func strikethrough(_ strikethrough: TypographyLineValue?) -> Self
}

extension DecorableByStrikethrough {

    public func strikethrough() -> Self {
        strikethrough(.single)
    }
}
#endif
