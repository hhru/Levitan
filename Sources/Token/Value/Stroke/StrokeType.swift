import Foundation

@frozen
public enum StrokeType: TokenTraitProvider, Sendable {

    case inside
    case outside
    case center
}
