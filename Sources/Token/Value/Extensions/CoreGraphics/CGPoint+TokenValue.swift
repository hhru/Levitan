import CoreGraphics

extension CGPoint: @retroactive @unchecked Sendable, TokenValue { }

extension CGPoint: @retroactive Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}
