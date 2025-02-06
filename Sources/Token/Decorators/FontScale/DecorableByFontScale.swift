#if canImport(UIKit)
import Foundation

public protocol DecorableByFontScale {

    func fontScale(_ fontScale: FontScaleValue?) -> Self
}
#endif
