#if canImport(UIKit)
import SwiftUI

internal struct ShadowModifier<Content: View>: TokenShapedModifier {

    internal let shadow: ShadowToken?

    internal let shape: ShapeToken?
    internal let shapeInsets: SpacingToken?

    private func dropShadowBody(
        content: Content,
        shadow: ShadowValue,
        shape: ShapeValue,
        shapeInsets: CGFloat
    ) -> some View {
        let color = shadow.color?.color ?? .clear

        let shadowShape = ShadowShape(
            shadow: shadow,
            shape: shape,
            shapeInsets: shapeInsets
        )

        let shadowMaskShape = ShadowMaskShape(
            shadow: shadow,
            shape: shape,
            shapeInsets: shapeInsets
        )

        let background = shadowShape
            .if(shadow.isSpreaded) { shadowShape in
                shadowShape.fill(color.opacity(.nan))
            }
            .shadow(
                color: color,
                radius: shadow.radius,
                x: shadow.offset.width,
                y: shadow.offset.height
            )
            .mask(shadowMaskShape)

        return content.background(background)
    }

    private func innerShadowBody(
        content: Content,
        shadow: ShadowValue,
        shape: ShapeValue,
        shapeInsets: CGFloat
    ) -> some View {
        let color = shadow.color?.color ?? .clear

        let shadowShape = ShadowShape(
            shadow: shadow,
            shape: shape,
            shapeInsets: shapeInsets
        )

        let shadowMaskShape = ShadowMaskShape(
            shadow: shadow,
            shape: shape,
            shapeInsets: shapeInsets
        )

        let overlay = shadowShape
            .if(shadow.isSpreaded) { shadowShape in
                shadowShape.fill(color.opacity(.nan))
            }
            .shadow(
                color: color,
                radius: shadow.radius,
                x: shadow.offset.width,
                y: shadow.offset.height
            )
            .mask(shadowMaskShape)

        return content.overlay(overlay)
    }

    @ViewBuilder
    internal func body(content: Content, theme: TokenTheme) -> some View {
        if let shadow = shadow?.resolve(for: theme), !shadow.isClear {
            let shape = shape?.resolve(for: theme) ?? .rectangle
            let shapeInsets = shapeInsets?.resolve(for: theme) ?? .zero

            switch shadow.type {
            case .drop:
                dropShadowBody(
                    content: content,
                    shadow: shadow,
                    shape: shape,
                    shapeInsets: shapeInsets
                )

            case .inner:
                innerShadowBody(
                    content: content,
                    shadow: shadow,
                    shape: shape,
                    shapeInsets: shapeInsets
                )
            }
        } else {
            content
        }
    }
}

extension View {

    public func shadow(
        _ shadow: ShadowToken?,
        shape: ShapeToken? = nil,
        shapeInsets: SpacingToken? = nil
    ) -> some TokenShapedView {
        modifier(
            ShadowModifier(
                shadow: shadow,
                shape: shape,
                shapeInsets: shapeInsets
            )
        )
    }

    public func shadow(
        _ shadow: ShadowToken?,
        corners: CornersToken,
        shapeInsets: SpacingToken? = nil
    ) -> some TokenShapedView {
        self.shadow(
            shadow,
            shape: .rectangle(corners: corners),
            shapeInsets: shapeInsets
        )
    }
}

extension TokenShapedView {

    public nonisolated func shadow(_ shadow: ShadowToken?) -> some TokenShapedView {
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
