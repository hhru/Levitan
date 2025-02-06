#if canImport(UIKit1)
import UIKit

public protocol DecorableByLineBreakMode {

    func lineBreakMode(_ lineBreakMode: NSLineBreakMode?) -> Self
}
#endif
