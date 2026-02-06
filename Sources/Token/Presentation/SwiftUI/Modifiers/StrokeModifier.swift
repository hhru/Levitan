#if canImport(UIKit)
import SwiftUI

public struct StrokeModifier<Content: View>: Hashable, Sendable {

    public let stroke: StrokeToken?
    public let shape: ShapeToken?

    public init(
        stroke: StrokeToken?,
        shape: ShapeToken?
    ) {
        self.stroke = stroke
        self.shape = shape
    }
}

extension StrokeModifier: TokenViewModifier {

    public func body(content: Content, theme: TokenTheme) -> some View {
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

extension StrokeModifier: TokenShapedModifier {

    public var shapeInsets: SpacingToken? {
        stroke?.insets
    }
}

extension View {

    public nonisolated func stroke(
        _ stroke: StrokeToken?,
        shape: ShapeToken? = nil
    ) -> TokenModifiedView<StrokeModifier<Self>> {
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
    ) -> TokenModifiedView<StrokeModifier<Self>> {
        modifier(
            StrokeModifier(
                stroke: stroke,
                shape: .rectangle(corners: corners)
            )
        )
    }
}

extension View where Self: TokenShapedView {

    public nonisolated func stroke(
        _ stroke: StrokeToken?
    ) -> TokenModifiedView<StrokeModifier<Self>> {
        modifier(
            StrokeModifier(
                stroke: stroke,
                shape: shape
            )
        )
    }
}
#endif
