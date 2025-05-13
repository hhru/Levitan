#if canImport(UIKit)
import Foundation

public protocol TextPart: Hashable, Sendable {

    var isEnabled: Bool { get }
    var tapAction: (@MainActor () -> Void)? { get }

    @MainActor
    func attributedText(context: ComponentContext) -> NSAttributedString
}

extension TextPart {

    public var isEnabled: Bool {
        true
    }

    public var tapAction: (@MainActor () -> Void)? {
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
