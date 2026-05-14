#if canImport(UIKit)
import SwiftUI

public struct ShadowModifier<Content: View>:
    TokenShapedModifier,
    Hashable,
    Sendable {

    public let shadow: ShadowToken?

    public let shape: ShapeToken?
    public let shapeInsets: SpacingToken?

    public init(
        shadow: ShadowToken?,
        shape: ShapeToken?,
        shapeInsets: SpacingToken?
    ) {
        self.shadow = shadow
        self.shape = shape
        self.shapeInsets = shapeInsets
    }
}

extension ShadowModifier: TokenViewModifier {

    public func body(content: Content, theme: TokenTheme) -> some View {
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

extension ShadowModifier {

    private func dropShadowBody(
        content: Content,
        shadow: ShadowValue,
        shape: AnyShapeValue,
        shapeInsets: CGFloat
    ) -> some View {
        let color = shadow.color.color

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
        shape: AnyShapeValue,
        shapeInsets: CGFloat
    ) -> some View {
        let color = shadow.color.color

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
}

extension View {

    public nonisolated func shadow(
        _ shadow: ShadowToken?,
        shape: ShapeToken? = nil,
        shapeInsets: SpacingToken? = nil
    ) -> TokenModifiedView<ShadowModifier<Self>> {
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
    ) -> TokenModifiedView<ShadowModifier<Self>> {
        self.shadow(
            shadow,
            shape: .rectangle(corners: corners),
            shapeInsets: shapeInsets
        )
    }
}

extension View where Self: TokenShapedView {

    public nonisolated func shadow(
        _ shadow: ShadowToken?
    ) -> TokenModifiedView<ShadowModifier<Self>> {
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
