import Foundation

extension FloatingPoint {

    internal var nonZero: Self? {
        isZero ? nil : self
    }
}
