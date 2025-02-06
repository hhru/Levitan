#if canImport(UIKit1)
import QuartzCore

extension CALayer {

    internal var maskLayer: MaskLayer? {
        mask as? MaskLayer
    }

    internal var maskShape: ShapeValue {
        maskLayer?.shape ?? .rectangle
    }

    internal func setupMaskLayer(shape: ShapeValue, frame: CGRect) {
        let maskLayer = MaskLayer()

        maskLayer.name = "\(MaskLayer.self)"
        maskLayer.frame = frame
        maskLayer.shape = shape

        mask = maskLayer

        if shape != .rectangle {
            updateFrontLayerIfNeeded()
            updateBackLayerIfNeeded()
        }
    }

    internal func updateShape(_ shape: ShapeValue) {
        if let shapeLayer = self as? TokenShapeLayer {
            return shapeLayer.shape = shape
        }

        if let frontLayer {
            frontLayer.shape = shape
            frontLayer.mask = nil
        }

        guard let maskLayer else {
            return setupMaskLayer(
                shape: shape,
                frame: bounds
            )
        }

        maskLayer.shape = shape
        maskLayer.frame = bounds
    }
}
#endif
