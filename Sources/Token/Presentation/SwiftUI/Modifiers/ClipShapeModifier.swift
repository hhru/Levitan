import SwiftUI

internal struct ClipShapeModifier<Content: View>: TokenShapedModifier {

    internal let shape: ShapeToken?

    internal var shapeInsets: SpacingToken? {
        nil
    }

    @ViewBuilder
    internal func body(content: Content, theme: TokenTheme) -> some View {
        if let shape = shape?.resolve(for: theme) {
            content.clipShape(shape)
        } else {
            content
        }
    }
}

extension View {

    public func clipShape(_ shape: ShapeToken?) -> some TokenShapedView {
        modifier(ClipShapeModifier(shape: shape))
    }

    public func corners(_ corners: CornersToken?) -> some TokenShapedView {
        clipShape(corners.map { .rectangle(corners: $0) })
    }

    public func corners(
        radius: CornerRadiusToken?,
        mask: CornersMask = .all
    ) -> some TokenShapedView {
        corners(radius.map { CornersToken(radius: $0, mask: mask) })
    }
}
