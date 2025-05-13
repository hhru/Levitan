#if canImport(UIKit)
import QuartzCore

@objc
private final class LayerAndIndex: NSObject {

    let layer: CALayer
    let index: UInt32

    init(_ layer: CALayer, _ index: UInt32) {
        self.layer = layer
        self.index = index
    }
}

@objc
private final class LayerPair: NSObject {

    let layer: CALayer
    let sublayer: CALayer?

    init(_ layer: CALayer, _ sublayer: CALayer?) {
        self.layer = layer
        self.sublayer = sublayer
    }
}

extension CALayer: TokenView {

    internal var tokenViewRoot: TokenView? {
        nil
    }

    internal var tokenViewParent: TokenView? {
        if let view = delegate as? TokenView {
            return view
        }

        return superlayer
    }

    internal var tokenViewChildren: [TokenView] {
        sublayers?.filter { sublayer in
            sublayer.tokenViewParent === self
        } ?? []
    }

    internal func overrideUserInterfaceStyle(themeScheme: TokenThemeScheme) { }
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

    @objc
    private dynamic func _addSublayer(_ layer: CALayer) {
        performOnMain(#selector(addSublayerOnMain(_:)), layer)
    }

    @objc
    private dynamic func _insertSublayer(_ layer: CALayer, at index: UInt32) {
        performOnMain(#selector(insertSublayerOnMain(_:)), LayerAndIndex(layer, index))
    }

    @objc
    private dynamic func _insertSublayer(_ layer: CALayer, above sublayer: CALayer?) {
        performOnMain(#selector(insertSublayerAboveOnMain(_:)), LayerPair(layer, sublayer))
    }

    @objc
    private dynamic func _insertSublayer(_ layer: CALayer, below sublayer: CALayer?) {
        performOnMain(#selector(insertSublayerBelowOnMain(_:)), LayerPair(layer, sublayer))
    }

    @objc
    private dynamic func _layoutSublayers() {
        performOnMain(#selector(layoutSublayersOnMain), nil)
    }

    private func performOnMain(_ selector: Selector, _ object: Any?) {
        if Thread.isMainThread {
            perform(selector, with: object)
        } else {
            perform(
                selector,
                on: Thread.main,
                with: object,
                waitUntilDone: false
            )
        }
    }

    @MainActor
    @objc
    private func addSublayerOnMain(_ layer: CALayer) {
        if let frontLayer {
            _insertSublayer(layer, below: frontLayer)
        } else {
            _addSublayer(layer)
        }
        applyThemeIfNeeded(for: layer)
    }

    @MainActor
    @objc
    private func insertSublayerOnMain(_ box: LayerAndIndex) {
        let layer = box.layer
        let index = box.index

        if let frontLayer, index == sublayers?.count ?? .zero {
            _insertSublayer(layer, below: frontLayer)
        } else if let backLayer, index == .zero {
            _insertSublayer(layer, above: backLayer)
        } else {
            _insertSublayer(layer, at: index)
        }

        applyThemeIfNeeded(for: layer)
    }

    @MainActor
    @objc
    private func insertSublayerAboveOnMain(_ pair: LayerPair) {
        let layer = pair.layer
        let sublayer = pair.sublayer

        if let frontLayer, frontLayer === sublayer {
            _insertSublayer(layer, below: frontLayer)
        } else {
            _insertSublayer(layer, above: sublayer)
        }

        applyThemeIfNeeded(for: layer)
    }

    @MainActor
    @objc
    private func insertSublayerBelowOnMain(_ pair: LayerPair) {
        let layer = pair.layer
        let sublayer = pair.sublayer

        if let backLayer, backLayer === sublayer {
            _insertSublayer(layer, above: backLayer)
        } else {
            _insertSublayer(layer, below: sublayer)
        }

        applyThemeIfNeeded(for: layer)
    }

    @MainActor
    @objc
    private func layoutSublayersOnMain(_: Any?) {
        _layoutSublayers()

        frontLayer?.frame = bounds
        backLayer?.frame = bounds

        if !(superlayer is TokenShapeLayer) {
            maskLayer?.frame = bounds
        }
    }

    @MainActor
    private func applyThemeIfNeeded(for layer: CALayer) {
        if layer.tokenViewParent === self {
            layer.tokenViewManager.updateTheme()
        }
    }
}
#endif
