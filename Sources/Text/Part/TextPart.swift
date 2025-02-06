#if canImport(UIKit1)
import Foundation

public protocol TextPart: Hashable {

    var isEnabled: Bool { get }
    var tapAction: (() -> Void)? { get }

    func attributedText(context: ComponentContext) -> NSAttributedString
}

extension TextPart {

    public var isEnabled: Bool {
        true
    }

    public var tapAction: (() -> Void)? {
        nil
    }

    internal func isEqual(to other: any TextPart) -> Bool {
        guard let other = other as? Self else {
            return false
        }

        return self == other
    }
}
#endif
