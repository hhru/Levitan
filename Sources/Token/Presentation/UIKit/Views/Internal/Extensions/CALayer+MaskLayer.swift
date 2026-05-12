#if canImport(UIKit)
import QuartzCore

extension CALayer {

    internal var maskLayer: MaskLayer? {
        mask as? MaskLayer
    }

    #if swift(<6.0)
    @MainActor
    #endif
    internal var maskShape: AnyShapeValue {
        maskLayer?.shape ?? .rectangle
    }

    #if swift(<6.0)
    @MainActor
    #endif
    internal func setupMaskLayer(shape: AnyShapeValue, frame: CGRect) {
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

    #if swift(<6.0)
    @MainActor
    #endif
    internal func updateShape(_ shape: AnyShapeValue) {
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
