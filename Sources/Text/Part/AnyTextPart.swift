#if canImport(UIKit)
import Foundation

public struct AnyTextPart {

    private let wrapped: any TextPart

    public init<Wrapped: TextPart>(_ wrapped: Wrapped) {
        if let wrapped = wrapped as? Self {
            self = wrapped
        } else {
            self.wrapped = wrapped
        }
    }
}

extension AnyTextPart: TextPart {

    public var isEnabled: Bool {
        wrapped.isEnabled
    }

    public var tapAction: (@Sendable @MainActor () -> Void)? {
        wrapped.tapAction
    }

    public func attributedText(context: ComponentContext) -> NSAttributedString {
        wrapped.attributedText(context: context)
    }
}

extension AnyTextPart: Hashable {

    public func hash(into hasher: inout Hasher) {
        wrapped.hash(into: &hasher)
    }
}

extension AnyTextPart: Equatable {

    public static func == (lhs: Self, rhs: Self) -> Bool {
        if lhs.wrapped.isEqual(to: rhs.wrapped) {
            return true
        }

        if let lhs = lhs.wrapped as? Self {
            return lhs == rhs
        }

        if let rhs = rhs.wrapped as? Self {
            return lhs == rhs
        }

        return false
    }
}

extension TextPart {

    public func eraseToAnyTextPart() -> AnyTextPart {
        AnyTextPart(self)
    }
}
#endif
