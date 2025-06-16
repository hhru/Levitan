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

    public mutating func appendInterpolation(_ part: any TextPart) {
        parts.append(part.eraseToAnyTextPart())
    }
}
#endif
