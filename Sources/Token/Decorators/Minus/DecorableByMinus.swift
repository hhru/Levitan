import Foundation

public protocol DecorableByMinus {

    static func - (lhs: Self, rhs: Self) -> Self
}

extension DecorableByMinus {

    public static func -= (lhs: inout Self, rhs: Self) {
        lhs = lhs - rhs
    }
}
