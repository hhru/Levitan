#if canImport(UIKit1)
import Foundation

public protocol AnyTokenView: NSObject {

    var tokenViewManager: TokenViewManager { get }
}
#endif
