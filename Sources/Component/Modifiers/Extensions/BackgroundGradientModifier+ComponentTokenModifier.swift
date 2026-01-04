#if canImport(UIKit)
import Foundation

extension BackgroundGradientModifier: ComponentTokenModifier where Content: Component { }

extension Component {

    public nonisolated func backgroundGradient(_ gradient: GradientToken?) -> some Component {
        modifier(BackgroundGradientModifier(gradient: gradient))
    }
}
#endif
