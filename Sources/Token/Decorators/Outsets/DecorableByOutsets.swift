import Foundation

public protocol DecorableByOutsets {

    func outset(by outsets: InsetsValue) -> Self
}

extension DecorableByOutsets {

    public func outset(_ edge: InsetsEdge, _ value: CGFloat) -> Self {
        outset(by: InsetsValue(edge, value))
    }

    public func outset(by value: CGFloat) -> Self {
        outset(by: InsetsValue(all: value))
    }

    public func outsetBy(
        top: CGFloat = .zero,
        leading: CGFloat = .zero,
        bottom: CGFloat = .zero,
        trailing: CGFloat = .zero
    ) -> Self {
        outset(
            by: InsetsValue(
                top: top,
                leading: leading,
                bottom: bottom,
                trailing: trailing
            )
        )
    }
}
