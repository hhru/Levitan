#if canImport(UIKit)
import Foundation

extension AnimationModifier: ComponentTokenModifier where Content: Component { }

extension Component {

    public nonisolated func animation<Value: Equatable>(
        _ animation: AnimationToken?,
        value: Value
    ) -> some Component {
        modifier(
            AnimationModifier(
                animation: animation,
                value: value
            )
        )
    }
}
#endif
