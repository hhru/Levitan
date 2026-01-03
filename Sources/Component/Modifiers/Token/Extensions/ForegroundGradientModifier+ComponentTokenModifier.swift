#if canImport(UIKit)
import Foundation

extension ForegroundGradientModifier: ComponentTokenModifier
where Content: Component { }

extension Component {

    public nonisolated func foregroundGradient(_ gradient: GradientToken?) -> some Component {
        modifier(ForegroundGradientModifier(gradient: gradient))
    }
}
#endif
