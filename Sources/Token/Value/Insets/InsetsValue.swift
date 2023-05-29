import UIKit
import SwiftUI

public struct InsetsValue:
    TokenValue,
    DecorableByPlus,
    DecorableByMinus,
    ExpressibleByIntegerLiteral,
    ExpressibleByFloatLiteral,
    Sendable {

    public let top: CGFloat
    public let leading: CGFloat
    public let bottom: CGFloat
    public let trailing: CGFloat

    public var horizontal: CGFloat {
        leading + trailing
    }

    public var vertical: CGFloat {
        top + bottom
    }

    public var uiEdgeInsets: UIEdgeInsets {
        UIEdgeInsets(
            top: top,
            left: leading,
            bottom: bottom,
            right: trailing
        )
    }

    public var edgeInsets: EdgeInsets {
        EdgeInsets(
            top: top,
            leading: leading,
            bottom: bottom,
            trailing: trailing
        )
    }

    public init(
        top: CGFloat,
        leading: CGFloat,
        bottom: CGFloat,
        trailing: CGFloat
    ) {
        self.top = top
        self.leading = leading
        self.bottom = bottom
        self.trailing = trailing
    }

    public init(_ edge: InsetsEdge, _ value: CGFloat) {
        self.init(
            top: edge.contains(.top) ? value : .zero,
            leading: edge.contains(.leading) ? value : .zero,
            bottom: edge.contains(.bottom) ? value : .zero,
            trailing: edge.contains(.trailing) ? value : .zero
        )
    }

    public init(all value: CGFloat) {
        self.init(
            top: value,
            leading: value,
            bottom: value,
            trailing: value
        )
    }

    public init(_ uiEdgeInset: UIEdgeInsets) {
        self.init(
            top: uiEdgeInset.top,
            leading: uiEdgeInset.left,
            bottom: uiEdgeInset.bottom,
            trailing: uiEdgeInset.right
        )
    }

    public init(_ edgeInset: EdgeInsets) {
        self.init(
            top: edgeInset.top,
            leading: edgeInset.leading,
            bottom: edgeInset.bottom,
            trailing: edgeInset.trailing
        )
    }

    public init(floatLiteral value: Double) {
        self.init(all: CGFloat(value))
    }

    public init(integerLiteral value: Int) {
        self.init(all: CGFloat(value))
    }
}

extension InsetsValue {

    public static var zero: Self {
        all(.zero)
    }

    public static func all(_ value: CGFloat) -> Self {
        Self(all: value)
    }

    public static func + (lhs: Self, rhs: Self) -> Self {
        Self(
            top: lhs.top + rhs.top,
            leading: lhs.leading + rhs.leading,
            bottom: lhs.bottom + rhs.bottom,
            trailing: lhs.trailing + rhs.trailing
        )
    }

    public static func - (lhs: Self, rhs: Self) -> Self {
        Self(
            top: lhs.top - rhs.top,
            leading: lhs.leading - rhs.leading,
            bottom: lhs.bottom - rhs.bottom,
            trailing: lhs.trailing - rhs.trailing
        )
    }
}
