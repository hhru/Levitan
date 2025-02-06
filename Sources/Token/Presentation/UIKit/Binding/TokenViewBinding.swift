#if canImport(UIKit)
import Foundation

internal protocol TokenViewBinding {

    func handle(view: TokenView, theme: TokenTheme)
}
#endif
