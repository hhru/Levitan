#if canImport(UIKit1)
import UIKit

public protocol DecorableByAlignment {

    func alignment(_ alignment: NSTextAlignment?) -> Self
}
#endif
