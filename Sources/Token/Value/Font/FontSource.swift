import UIKit

public enum FontSource: TokenTraitProvider, Sendable {

    case uiFont(
        trait: TokenTrait,
        builder: @Sendable (_ size: CGFloat) -> UIFont
    )

    case resource(weight: String)
}

extension FontSource: Equatable {

    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case let (.uiFont(lhsTrait, _), .uiFont(rhsTrait, _)):
            return lhsTrait == rhsTrait

        case let (.resource(lhsWeight), .resource(rhsWeight)):
            return lhsWeight == rhsWeight

        default:
            return false
        }
    }
}

extension FontSource: Hashable {

    public func hash(into hasher: inout Hasher) {
        switch self {
        case let .uiFont(trait, _):
            hasher.combine(trait)

        case let .resource(weight):
            hasher.combine(weight)
        }
    }
}
