#if canImport(UIKit1)
import Foundation

public protocol DecorableByFontScale {

    func fontScale(_ fontScale: FontScaleValue?) -> Self
}
#endif
