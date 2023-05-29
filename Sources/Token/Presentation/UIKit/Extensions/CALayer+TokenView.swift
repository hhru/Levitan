import QuartzCore

extension CALayer: TokenView {

    internal var tokenViewParent: TokenView? {
        if let view = delegate as? TokenView {
            return view
        }

        return superlayer
    }

    internal var tokenViewChildren: [TokenView] {
        sublayers?.filter { sublayer in
            sublayer.tokenViewParent === self
        } ?? .empty
    }

    internal func overrideUserInterfaceStyle(themeScheme: TokenThemeScheme?) { }
}

extension CALayer {

    internal static func observeTokenViewEvents() {
        MethodSwizzler.swizzle(
            class: CALayer.self,
            originalSelector: #selector(CALayer.addSublayer(_:)),
            swizzledSelector: #selector(CALayer.addTokenViewSublayer(_:))
        )

        MethodSwizzler.swizzle(
            class: CALayer.self,
            originalSelector: #selector(CALayer.insertSublayer(_:at:)),
            swizzledSelector: #selector(CALayer.insertTokenViewSublayer(_:at:))
        )

        MethodSwizzler.swizzle(
            class: CALayer.self,
            originalSelector: #selector(CALayer.insertSublayer(_:above:)),
            swizzledSelector: #selector(CALayer.insertTokenViewSublayer(_:above:))
        )

        MethodSwizzler.swizzle(
            class: CALayer.self,
            originalSelector: #selector(CALayer.insertSublayer(_:below:)),
            swizzledSelector: #selector(CALayer.insertTokenViewSublayer(_:below:))
        )

        MethodSwizzler.swizzle(
            class: CALayer.self,
            originalSelector: #selector(CALayer.layoutSublayers),
            swizzledSelector: #selector(CALayer.layoutTokenViewSublayers)
        )
    }

    @objc
    private dynamic func addTokenViewSublayer(_ layer: CALayer) {
        if let frontLayer {
            insertTokenViewSublayer(layer, below: frontLayer)
        } else {
            addTokenViewSublayer(layer)
        }

        if layer.tokenViewParent === self {
            layer.tokenViewManager.updateTheme()
        }
    }

    @objc
    private dynamic func insertTokenViewSublayer(_ layer: CALayer, at index: UInt32) {
        if let frontLayer, index == sublayers?.count ?? .zero {
            insertTokenViewSublayer(layer, below: frontLayer)
        } else if let backLayer, index == .zero {
            insertTokenViewSublayer(layer, above: backLayer)
        } else {
            insertTokenViewSublayer(layer, at: index)
        }

        if layer.tokenViewParent === self {
            layer.tokenViewManager.updateTheme()
        }
    }

    @objc
    private dynamic func insertTokenViewSublayer(_ layer: CALayer, above sublayer: CALayer?) {
        if let frontLayer, frontLayer === sublayer {
            insertTokenViewSublayer(layer, below: frontLayer)
        } else {
            insertTokenViewSublayer(layer, above: sublayer)
        }

        if layer.tokenViewParent === self {
            layer.tokenViewManager.updateTheme()
        }
    }

    @objc
    private dynamic func insertTokenViewSublayer(_ layer: CALayer, below sublayer: CALayer?) {
        if let backLayer, backLayer === sublayer {
            insertTokenViewSublayer(layer, above: backLayer)
        } else {
            insertTokenViewSublayer(layer, below: sublayer)
        }

        if layer.tokenViewParent === self {
            layer.tokenViewManager.updateTheme()
        }
    }

    @objc
    private dynamic func layoutTokenViewSublayers() {
        layoutTokenViewSublayers()

        frontLayer?.frame = bounds
        backLayer?.frame = bounds

        if !(superlayer is TokenShapeLayer) {
            maskLayer?.frame = bounds
        }
    }
}
