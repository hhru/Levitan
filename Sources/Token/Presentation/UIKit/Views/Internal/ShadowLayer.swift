#if canImport(UIKit)
import UIKit

internal final class ShadowLayer: CALayer {

    internal var shadow: ShadowValue {
        didSet {
            if shadow != oldValue {
                updateShadow()
            }
        }
    }

    internal var stroke: StrokeValue? {
        didSet {
            if stroke != oldValue {
                updateShadowPathIfPossible()
            }
        }
    }

    internal var shape: ShapeValue {
        didSet {
            if shape != oldValue {
                updateShadowPathIfPossible()
            }
        }
    }

    internal init(
        shadow: ShadowValue,
        stroke: StrokeValue?,
        shape: ShapeValue
    ) {
        self.shadow = shadow
        self.stroke = stroke
        self.shape = shape

        super.init()

        updateShadow()
    }

    internal override init(layer: Any) {
        if let layer = layer as? Self {
            shadow = layer.shadow
            stroke = layer.stroke
            shape = layer.shape
        } else {
            shadow = .clear
            stroke = nil
            shape = .rectangle
        }

        super.init(layer: layer)
    }

    @available(*, unavailable)
    internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func shapePath(insets: CGFloat) -> CGPath {
        shape.path(size: bounds.size, insets: insets)
    }

    private func updateDropShadowPath(insets: CGFloat) {
        shadowPath = shapePath(insets: insets - shadow.spread)

        let maskInsets = insets
            - shadow.spread
            - shadow.radius * 2.0
            - 4.0

        let maskExternalRect = bounds
            .insetBy(dx: maskInsets, dy: maskInsets)
            .offsetBy(dx: shadow.offset.width, dy: shadow.offset.height)

        let maskExternalPath = CGPath(rect: maskExternalRect, transform: nil)
        let maskInternalPath = shapePath(insets: insets)

        let maskPath: CGPath

        if #available(iOS 16.0, tvOS 16.0, *) {
            maskPath = maskExternalPath.subtracting(maskInternalPath)
        } else {
            let bezierPath = UIBezierPath()

            bezierPath.append(UIBezierPath(cgPath: maskExternalPath))
            bezierPath.append(UIBezierPath(cgPath: maskInternalPath).reversing())

            maskPath = bezierPath.cgPath
        }

        if let maskLayer = mask as? CAShapeLayer {
            maskLayer.path = maskPath
            maskLayer.frame = bounds
        } else {
            let maskLayer = CAShapeLayer()

            maskLayer.path = maskPath
            maskLayer.frame = bounds

            mask = maskLayer
        }
    }

    private func updateInnerShadowPath(insets: CGFloat) {
        let externalRectInsets = insets
            - shadow.radius * 2.0
            - shadow.spread
            - 4.0

        let externalRect = bounds.insetBy(
            dx: externalRectInsets,
            dy: externalRectInsets
        )

        let internalPath = shapePath(insets: insets + shadow.spread)

        if #available(iOS 16.0, tvOS 16.0, *) {
            let externalPath = CGPath(rect: externalRect, transform: nil)

            shadowPath = externalPath.subtracting(internalPath)
        } else {
            let bezierPath = UIBezierPath()

            bezierPath.append(UIBezierPath(rect: externalRect))
            bezierPath.append(UIBezierPath(cgPath: internalPath).reversing())

            shadowPath = bezierPath.cgPath
        }

        let maskPath = shapePath(insets: insets)

        if let maskLayer = mask as? CAShapeLayer {
            maskLayer.path = maskPath
            maskLayer.frame = bounds
        } else {
            let maskLayer = CAShapeLayer()

            maskLayer.path = maskPath
            maskLayer.frame = bounds

            mask = maskLayer
        }
    }

    private func updateShadowPathIfPossible() {
        guard !bounds.isEmpty else {
            return
        }

        let insets = stroke?.insets ?? .zero

        switch shadow.type {
        case .drop:
            updateDropShadowPath(insets: insets)

        case .inner:
            updateInnerShadowPath(insets: insets)
        }
    }

    private func updateShadow() {
        shadowColor = shadow.color?.alpha(1.0).cgColor ?? .black
        shadowOffset = shadow.offset
        shadowRadius = shadow.radius
        shadowOpacity = Float(shadow.color?.alpha ?? .zero)

        updateShadowPathIfPossible()
    }

    internal override func layoutSublayers() {
        super.layoutSublayers()

        updateShadowPathIfPossible()
    }
}
#endif
