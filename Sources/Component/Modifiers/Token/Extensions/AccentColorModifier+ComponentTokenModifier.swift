#if canImport(UIKit)
import Foundation

extension AccentColorModifier: ComponentTokenModifier
where Content: Component { }

extension Component {

    public nonisolated func accentColor(_ color: ColorToken?) -> some Component {
        modifier(AccentColorModifier(color: color))
    }
}
#endif
