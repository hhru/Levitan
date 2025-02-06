#if canImport(UIKit)
import UIKit

open class TokenShapeView: UIView {

    public override class var layerClass: AnyClass {
        TokenShapeLayer.self
    }
}
#endif
