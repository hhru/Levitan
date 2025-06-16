#if canImport(UIKit)
import Foundation

public struct AnyTextDecorator: TextDecorator {

    private let wrapped: any TextDecorator

    public init<Wrapped: TextDecorator>(_ wrapped: Wrapped) {
        if let wrapped = wrapped as? Self {
            self = wrapped
        } else {
            self.wrapped = wrapped
        }
    }

    public func decorate(
        typography: TypographyValue,
        context: ComponentContext
    ) -> TypographyValue {
        wrapped.decorate(
            typography: typography,
            context: context
        )
    }
}

extension AnyTextDecorator: Hashable {

    public func hash(into hasher: inout Hasher) {
        wrapped.hash(into: &hasher)
    }
}

extension AnyTextDecorator: Equatable {

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

extension TextDecorator {

    public func eraseToAnyTextDecorator() -> AnyTextDecorator {
        AnyTextDecorator(self)
    }
}
#endif
