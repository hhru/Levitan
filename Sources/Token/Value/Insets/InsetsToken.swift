#if canImport(UIKit1)
import UIKit
#endif

import SwiftUI

public typealias InsetsToken = Token<InsetsValue>

extension InsetsToken {

    public init(
        top: SpacingToken,
        leading: SpacingToken,
        bottom: SpacingToken,
        trailing: SpacingToken
    ) {
        self = Token(traits: [top, leading, bottom, trailing]) { theme in
            Value(
                top: top.resolve(for: theme),
                leading: leading.resolve(for: theme),
                bottom: bottom.resolve(for: theme),
                trailing: trailing.resolve(for: theme)
            )
        }
    }

    public init(_ edge: InsetsEdge, _ value: SpacingToken) {
        self.init(
            top: edge.contains(.top) ? value : .zero,
            leading: edge.contains(.leading) ? value : .zero,
            bottom: edge.contains(.bottom) ? value : .zero,
            trailing: edge.contains(.trailing) ? value : .zero
        )
    }

    public init(all value: SpacingToken) {
        self.init(
            top: value,
            leading: value,
            bottom: value,
            trailing: value
        )
    }

    #if canImport(UIKit1)
    public init(_ uiEdgeInset: UIEdgeInsets) {
        self = InsetsValue(uiEdgeInset).token
    }
    #endif

    public init(_ edgeInset: EdgeInsets) {
        self = InsetsValue(edgeInset).token
    }
}

extension InsetsToken {

    public static var zero: Self {
        all(.zero)
    }

    public static func all(_ value: SpacingToken) -> Self {
        Self(all: value)
    }
}
