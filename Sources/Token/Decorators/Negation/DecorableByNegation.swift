import Foundation

public protocol DecorableByNegation {

    static prefix func - (value: Self) -> Self
}
