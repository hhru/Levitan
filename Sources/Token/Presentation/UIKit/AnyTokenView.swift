#if canImport(UIKit)
import Foundation

public protocol AnyTokenView: NSObject {

    var tokenViewManager: TokenViewManager { get }
}
#endif
