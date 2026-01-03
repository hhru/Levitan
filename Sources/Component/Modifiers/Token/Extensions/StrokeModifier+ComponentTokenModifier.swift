#if canImport(UIKit)
import Foundation

extension StrokeModifier: ComponentTokenModifier
where Content: Component { }

extension Component {

    public nonisolated func stroke(
        _ stroke: StrokeToken?,
        shape: ShapeToken? = nil
    ) -> some Component & TokenShapedView {
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
    ) -> some Component & TokenShapedView {
        modifier(
            StrokeModifier(
                stroke: stroke,
                shape: .rectangle(corners: corners)
            )
        )
    }
}

extension Component where Self: TokenShapedView {

    public nonisolated func stroke(_ stroke: StrokeToken?) -> some Component & TokenShapedView {
        modifier(
            StrokeModifier(
                stroke: stroke,
                shape: shape
            )
        )
    }
}
#endif
