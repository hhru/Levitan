import SwiftUI

public struct AnyShapeAnimatableData: Sendable {

    fileprivate var wrapped: (any VectorArithmetic & Sendable)?

    private let plusBox: @Sendable (_ lhs: Self, _ rhs: Self) -> Self
    private let minusBox: @Sendable (_ lhs: Self, _ rhs: Self) -> Self

    private init(
        wrapped: (any VectorArithmetic & Sendable)?,
        plusBox: @escaping @Sendable (_ lhs: Self, _ rhs: Self) -> Self,
        minusBox: @escaping @Sendable (_ lhs: Self, _ rhs: Self) -> Self
    ) {
        self.wrapped = wrapped

        self.plusBox = plusBox
        self.minusBox = minusBox
    }
}

extension AnyShapeAnimatableData {

    internal init<Wrapped: VectorArithmetic & Sendable>(_ wrapped: Wrapped) {
        self.init(
            wrapped: wrapped,
            plusBox: { lhs, rhs in
                guard let wrapped = lhs.wrapped as? Wrapped else {
                    return lhs
                }

                guard let other = rhs.wrapped as? Wrapped else {
                    return lhs
                }

                return Self(wrapped + other)
            },
            minusBox: { lhs, rhs in
                guard let wrapped = lhs.wrapped as? Wrapped else {
                    return lhs
                }

                guard let other = rhs.wrapped as? Wrapped else {
                    return lhs
                }

                return Self(wrapped - other)
            }
        )
    }
}

extension AnyShapeAnimatableData: Equatable {

    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs.wrapped, rhs.wrapped) {
        case let (lhs?, rhs?):
            lhs.isEqual(to: rhs)

        case let (lhs?, nil):
            lhs.isZero

        case let (nil, rhs?):
            rhs.isZero

        case (nil, nil):
            true
        }
    }
}

extension AnyShapeAnimatableData: AdditiveArithmetic {

    public static var zero: Self {
        Self(
            wrapped: nil,
            plusBox: { lhs, rhs in
                rhs.wrapped?.isZero ?? true
                    ? lhs
                    : rhs
            },
            minusBox: { lhs, rhs in
                rhs.wrapped?.isZero ?? true
                    ? lhs
                    : rhs - rhs - rhs
            }
        )
    }

    public static func + (lhs: Self, rhs: Self) -> Self {
        lhs.plusBox(lhs, rhs)
    }

    public static func - (lhs: Self, rhs: Self) -> Self {
        lhs.minusBox(lhs, rhs)
    }
}

extension AnyShapeAnimatableData: VectorArithmetic {

    public var magnitudeSquared: Double {
        wrapped?.magnitudeSquared ?? .zero
    }

    public mutating func scale(by factor: Double) {
        wrapped?.scale(by: factor)
    }
}

extension ShapeValue {

    internal var anyAnimatableData: AnyShapeAnimatableData {
        get { AnyShapeAnimatableData(animatableData) }

        set {
            if let newValue = newValue.wrapped as? AnimatableData {
                animatableData = newValue
            }
        }
    }
}
