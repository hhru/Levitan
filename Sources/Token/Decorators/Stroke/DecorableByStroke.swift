#if canImport(UIKit)
import Foundation

public protocol DecorableByStroke {

    func stroke(_ stroke: TypographyStrokeValue?) -> Self
}

extension DecorableByStroke {

    public func stroke() -> Self {
        stroke(1.0)
    }
}
#endif
