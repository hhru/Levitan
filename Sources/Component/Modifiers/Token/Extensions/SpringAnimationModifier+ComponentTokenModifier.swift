#if canImport(UIKit)
import Foundation

extension SpringAnimationModifier: ComponentTokenModifier
where Content: Component { }

extension Component {

    public nonisolated func springAnimation<Value: Equatable>(
        _ animation: SpringAnimationToken?,
        value: Value
    ) -> some Component {
        modifier(
            SpringAnimationModifier(
                animation: animation,
                value: value
            )
        )
    }
}
#endif
