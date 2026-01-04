#if canImport(UIKit)
import Foundation

extension ShadowModifier: ComponentTokenModifier where Content: Component { }

extension Component {

    public nonisolated func shadow(
        _ shadow: ShadowToken?,
        shape: ShapeToken? = nil,
        shapeInsets: SpacingToken? = nil
    ) -> some Component & TokenShapedView {
        modifier(
            ShadowModifier(
                shadow: shadow,
                shape: shape,
                shapeInsets: shapeInsets
            )
        )
    }

    public nonisolated func shadow(
        _ shadow: ShadowToken?,
        corners: CornersToken,
        shapeInsets: SpacingToken? = nil
    ) -> some Component & TokenShapedView {
        self.shadow(
            shadow,
            shape: .rectangle(corners: corners),
            shapeInsets: shapeInsets
        )
    }
}

extension Component where Self: TokenShapedView {

    public nonisolated func shadow(_ shadow: ShadowToken?) -> some Component & TokenShapedView {
        modifier(
            ShadowModifier(
                shadow: shadow,
                shape: shape,
                shapeInsets: shapeInsets
            )
        )
    }
}
#endif
