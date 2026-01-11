import CoreGraphics
import Foundation

public protocol CustomShape: TokenTraitProvider, Sendable {

    func isEqual(to other: CustomShape) -> Bool
    func hash(into hasher: inout Hasher)

    func path(size: CGSize, insets: CGFloat) -> CGPath
}

extension CustomShape where Self: Equatable {

    public func isEqual(to other: CustomShape) -> Bool {
        guard let other = other as? Self else {
            return false
        }

        return self == other
    }
}
