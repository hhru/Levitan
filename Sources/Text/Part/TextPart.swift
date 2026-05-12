#if canImport(UIKit)
import Foundation

public protocol TextPart: Hashable, Sendable {

    var isEnabled: Bool { get }
    var tapAction: (@Sendable @MainActor () -> Void)? { get }

    func attributedText(context: TextContext) -> NSAttributedString
}

extension TextPart {

    public var isEnabled: Bool {
        true
    }

    public var tapAction: (@Sendable @MainActor () -> Void)? {
        nil
    }
}
#endif
