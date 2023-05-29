import Foundation

public protocol DecorableByPlus {

    static func + (lhs: Self, rhs: Self) -> Self
}

extension DecorableByPlus {

    public static func += (lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }
}
