import CoreGraphics

extension CGSize:
    @retroactive @unchecked Sendable,
    TokenValue,
    DecorableByInsets,
    DecorableByOutsets {

    public func inset(by insets: InsetsValue) -> Self {
        Self(
            width: width - insets.horizontal,
            height: height - insets.vertical
        )
    }

    public func outset(by outsets: InsetsValue) -> Self {
        Self(
            width: width + outsets.horizontal,
            height: height + outsets.vertical
        )
    }
}

extension CGSize: @retroactive Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(width)
        hasher.combine(height)
    }
}
