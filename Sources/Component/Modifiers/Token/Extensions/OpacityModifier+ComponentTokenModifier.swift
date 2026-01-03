#if canImport(UIKit)
import Foundation

extension OpacityModifier: ComponentTokenModifier
where Content: Component { }

extension Component {

    public nonisolated func opacity(_ opacity: OpacityToken?) -> some Component {
        modifier(OpacityModifier(opacity: opacity))
    }
}
#endif
