import Foundation

public typealias ShapeToken = Token<ShapeValue>

extension ShapeToken {

    public static func custom<Shape: CustomShape>(_ shape: Token<Shape>) -> Self {
        Token(traits: [shape]) { theme in
            Value.custom(shape.resolve(for: theme))
        }
    }
}
