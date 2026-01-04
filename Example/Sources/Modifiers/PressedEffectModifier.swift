import Levitan
import SwiftUI

struct PressedEffectModifier: Equatable, Sendable {

    let isPressed: Bool
    let anchor: UnitPoint
}

extension PressedEffectModifier: ViewModifier {

    func body(content: Content) -> some View {
        content
            .scaleEffect(isPressed ? 0.95 : 1.0, anchor: anchor)
            .animation(
                isPressed
                    ? Animations.easeInOut200
                    : Animations.easeInOut100,
                value: isPressed
            )
    }
}

extension PressedEffectModifier: ComponentModifier {

    func sizing<Content: Component>(
        content: Content,
        fitting size: CGSize,
        context: ComponentContext
    ) -> ComponentSizing {
        content.sizing(
            fitting: size,
            context: context
        )
    }
}

extension View {

    nonisolated func pressedEffect(_ isPressed: Bool, anchor: UnitPoint = .center) -> some View {
        modifier(PressedEffectModifier(isPressed: isPressed, anchor: anchor))
    }
}

extension Component {

    nonisolated func pressedEffect(_ isPressed: Bool, anchor: UnitPoint = .center) -> some Component {
        modifier(PressedEffectModifier(isPressed: isPressed, anchor: anchor))
    }
}
