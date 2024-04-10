import Foundation

extension FloatingPoint {

    public var nonZero: Self? {
        isZero ? nil : self
    }
}
