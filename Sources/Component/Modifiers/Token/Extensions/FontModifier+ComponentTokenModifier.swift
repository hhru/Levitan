#if canImport(UIKit)
import Foundation

extension FontModifier: ComponentTokenModifier where Content: Component { }

extension Component {

    public nonisolated func font(_ font: FontToken?) -> some Component {
        modifier(FontModifier(font: font))
    }
}
#endif
