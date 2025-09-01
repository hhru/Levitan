#if canImport(UIKit)
import SwiftUI

internal struct StrokeModifier<Content: View>: TokenShapedModifier {

    internal let stroke: StrokeToken?
    internal let shape: ShapeToken?

    internal var shapeInsets: SpacingToken? {
        stroke?.shapeInsets
    }

    @ViewBuilder
    internal func body(content: Content, theme: TokenTheme) -> some View {
        if let stroke = stroke?.resolve(for: theme) {
            let shape = shape?.resolve(for: theme) ?? .rectangle
            let color = stroke.color?.color ?? .black

            let strokeShape = StrokeShape(
                stroke: stroke,
                shape: shape
            )

            content.overlay(strokeShape.fill(color))
        } else {
            content
        }
    }
}

extension View {

    public nonisolated func stroke(
        _ stroke: StrokeToken?,
        shape: ShapeToken? = nil
    ) -> some TokenShapedView {
        modifier(
            StrokeModifier(
                stroke: stroke,
                shape: shape
            )
        )
    }

    public nonisolated func stroke(
        _ stroke: StrokeToken?,
        corners: CornersToken
    ) -> some TokenShapedView {
        modifier(
            StrokeModifier(
                stroke: stroke,
                shape: .rectangle(corners: corners)
            )
        )
    }
}

extension TokenShapedView {

    public nonisolated func stroke(_ stroke: StrokeToken?) -> some TokenShapedView {
        modifier(
            StrokeModifier(
                stroke: stroke,
                shape: shape
            )
        )
    }
}
#endif
