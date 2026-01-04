#if canImport(UIKit)
import Foundation

extension BackgroundColorModifier: ComponentTokenModifier where Content: Component { }

extension Component {

    public nonisolated func backgroundColor(_ color: ColorToken?) -> some Component {
        modifier(BackgroundColorModifier(color: color))
    }
}
#endif
