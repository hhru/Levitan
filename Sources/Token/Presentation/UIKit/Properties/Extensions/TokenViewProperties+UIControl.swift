#if canImport(UIKit)
import UIKit

extension TokenViewProperties where View: UIControl {

    public struct ControlState: Hashable {

        public static var normal: Self {
            Self(state: .normal)
        }

        public let state: UIControl.State

        public subscript(for state: UIControl.State) -> Self {
            Self(state: state)
        }
    }
}

extension UIControl.State: Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}
#endif
