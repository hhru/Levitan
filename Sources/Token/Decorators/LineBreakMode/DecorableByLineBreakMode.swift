#if canImport(UIKit)
import UIKit

public protocol DecorableByLineBreakMode {

    func lineBreakMode(_ lineBreakMode: NSLineBreakMode?) -> Self
}
#endif
