#if canImport(UIKit1)
import Foundation

internal protocol TokenViewBinding {

    func handle(view: TokenView, theme: TokenTheme)
}
#endif
