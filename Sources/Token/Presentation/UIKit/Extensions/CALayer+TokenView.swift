#if canImport(UIKit)
import QuartzCore

extension CALayer: TokenView {

    internal nonisolated var tokenViewRoot: TokenView? {
        nil
    }

    internal nonisolated var tokenViewParent: TokenView? {
        if let view = delegate as? TokenView {
            return view
        }

        return superlayer
    }

    internal nonisolated var tokenViewChildren: [TokenView] {
        sublayers?.filter { sublayer in
            sublayer.tokenViewParent === self
        } ?? []
    }

    internal nonisolated func overrideUserInterfaceStyle(themeScheme: TokenThemeScheme) { }
}

extension CALayer {

    internal static func handleTokenViewEvents() {
        MethodSwizzler.swizzle(
            class: CALayer.self,
            originalSelector: #selector(CALayer.addSublayer(_:)),
            swizzledSelector: #selector(CALayer._addSublayer(_:))
        )

        MethodSwizzler.swizzle(
            class: CALayer.self,
            originalSelector: #selector(CALayer.insertSublayer(_:at:)),
            swizzledSelector: #selector(CALayer._insertSublayer(_:at:))
        )

        MethodSwizzler.swizzle(
            class: CALayer.self,
            originalSelector: #selector(CALayer.insertSublayer(_:above:)),
            swizzledSelector: #selector(CALayer._insertSublayer(_:above:))
        )

        MethodSwizzler.swizzle(
            class: CALayer.self,
            originalSelector: #selector(CALayer.insertSublayer(_:below:)),
            swizzledSelector: #selector(CALayer._insertSublayer(_:below:))
        )

        MethodSwizzler.swizzle(
            class: CALayer.self,
            originalSelector: #selector(CALayer.layoutSublayers),
            swizzledSelector: #selector(CALayer._layoutSublayers)
        )
    }

    private func updateThemeOnMainThread(layer: CALayer) {
        if Thread.isMainThread {
            perform(#selector(updateTheme), with: layer)
        } else {
            perform(
                #selector(updateTheme),
                on: Thread.main,
                with: layer,
                waitUntilDone: false
            )
        }
    }

    @MainActor
    @objc
    private dynamic func updateTheme() {
        tokenViewManager.updateTheme()
    }

    @objc
    private dynamic func _addSublayer(_ layer: CALayer) {
        if let frontLayer {
            _insertSublayer(layer, below: frontLayer)
        } else {
            _addSublayer(layer)
        }

        if layer.tokenViewParent === self {
            updateThemeOnMainThread(layer: layer)
        }
    }

    @objc
    private dynamic func _insertSublayer(_ layer: CALayer, at index: UInt32) {
        if let frontLayer, index == sublayers?.count ?? .zero {
            _insertSublayer(layer, below: frontLayer)
        } else if let backLayer, index == .zero {
            _insertSublayer(layer, above: backLayer)
        } else {
            _insertSublayer(layer, at: index)
        }

        if layer.tokenViewParent === self {
            updateThemeOnMainThread(layer: layer)
        }
    }

    @objc
    private dynamic func _insertSublayer(_ layer: CALayer, above sublayer: CALayer?) {
        if let frontLayer, frontLayer === sublayer {
            _insertSublayer(layer, below: frontLayer)
        } else {
            _insertSublayer(layer, above: sublayer)
        }

        if layer.tokenViewParent === self {
            updateThemeOnMainThread(layer: layer)
        }
    }

    @objc
    private dynamic func _insertSublayer(_ layer: CALayer, below sublayer: CALayer?) {
        if let backLayer, backLayer === sublayer {
            _insertSublayer(layer, above: backLayer)
        } else {
            _insertSublayer(layer, below: sublayer)
        }

        if layer.tokenViewParent === self {
            updateThemeOnMainThread(layer: layer)
        }
    }

    @objc
    private dynamic func _layoutSublayers() {
        _layoutSublayers()

        frontLayer?.frame = bounds
        backLayer?.frame = bounds

        if !(superlayer is TokenShapeLayer) {
            maskLayer?.frame = bounds
        }
    }
}
#endif
