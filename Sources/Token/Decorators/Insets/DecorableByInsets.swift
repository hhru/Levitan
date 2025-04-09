import CoreGraphics

public protocol DecorableByInsets {

    func inset(by insets: InsetsValue) -> Self
}

extension DecorableByInsets {

    public func inset(_ edge: InsetsEdge, _ value: CGFloat) -> Self {
        inset(by: InsetsValue(edge, value))
    }

    public func inset(by value: CGFloat) -> Self {
        inset(by: InsetsValue(all: value))
    }

    public func insetBy(
        top: CGFloat = .zero,
        leading: CGFloat = .zero,
        bottom: CGFloat = .zero,
        trailing: CGFloat = .zero
    ) -> Self {
        inset(
            by: InsetsValue(
                top: top,
                leading: leading,
                bottom: bottom,
                trailing: trailing
            )
        )
    }
}
