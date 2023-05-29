import Foundation

public protocol DecorableByDivision {

    static func / (lhs: Self, rhs: Self) -> Self
}
