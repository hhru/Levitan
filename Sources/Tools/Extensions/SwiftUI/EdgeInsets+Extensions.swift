#if canImport(UIKit)
import UIKit
#endif

import SwiftUI

extension EdgeInsets {

    internal static let zero = Self(all: .zero)

    internal var horizontal: CGFloat {
        leading + trailing
    }

    internal var vertical: CGFloat {
        top + bottom
    }

    #if canImport(UIKit)
    internal var uiEdgeInsets: UIEdgeInsets {
        UIEdgeInsets(
            top: top,
            left: leading,
            bottom: bottom,
            right: trailing
        )
    }
    #endif

    internal init(all length: CGFloat) {
        self.init(
            top: length,
            leading: length,
            bottom: length,
            trailing: length
        )
    }

    internal init(_ edge: Edge.Set, _ length: CGFloat) {
        self.init(
            top: edge.contains(.top) ? length : .zero,
            leading: edge.contains(.leading) ? length : .zero,
            bottom: edge.contains(.bottom) ? length : .zero,
            trailing: edge.contains(.trailing) ? length : .zero
        )
    }
}
