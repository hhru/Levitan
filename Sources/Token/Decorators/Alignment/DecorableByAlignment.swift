#if canImport(UIKit)
import UIKit

public protocol DecorableByAlignment {

    func alignment(_ alignment: NSTextAlignment?) -> Self
}
#endif
