import CoreGraphics

extension CGRect:
    @retroactive @unchecked Sendable,
    TokenValue { }

extension CGRect: DecorableByInsets {

    public func inset(by insets: InsetsValue) -> Self {
        Self(
            x: minX + insets.leading,
            y: minY + insets.top,
            width: width - insets.horizontal,
            height: height - insets.vertical
        )
    }
}

extension CGRect: DecorableByOutsets {

    public func outset(by outsets: InsetsValue) -> Self {
        Self(
            x: minX - outsets.leading,
            y: minY - outsets.top,
            width: width + outsets.horizontal,
            height: height + outsets.vertical
        )
    }
}

extension CGRect: @retroactive Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(origin)
        hasher.combine(size)
    }
}
