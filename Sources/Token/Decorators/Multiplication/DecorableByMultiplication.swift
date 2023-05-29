import Foundation

public protocol DecorableByMultiplication {

    static func * (lhs: Self, rhs: Self) -> Self
}
