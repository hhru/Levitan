#if canImport(UIKit)
import Foundation

extension ForegroundColorModifier: ComponentTokenModifier
where Content: Component { }

extension Component {

    public nonisolated func foregroundColor(_ color: ColorToken?) -> some Component {
        modifier(ForegroundColorModifier(color: color))
    }
}
#endif
