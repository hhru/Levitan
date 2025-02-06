#if canImport(UIKit)
import UIKit

public struct TextInterpolation: StringInterpolationProtocol {

    internal private(set) var parts: [AnyTextPart] = []

    public init(literalCapacity: Int, interpolationCount: Int) {
        parts.reserveCapacity(interpolationCount)
    }

    public mutating func appendLiteral(_ literal: String) {
        parts.append(literal.eraseToAnyTextPart())
    }

    public mutating func appendInterpolation(_ image: UIImage) {
        parts.append(image.eraseToAnyTextPart())
    }

    public mutating func appendInterpolation(_ image: ImageValue) {
        parts.append(image.eraseToAnyTextPart())
    }

    public mutating func appendInterpolation(_ image: ImageToken) {
        parts.append(image.eraseToAnyTextPart())
    }
}
#endif
