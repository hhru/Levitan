import SwiftUI

internal struct ClipShapeModifier<Content: View>:
    TokenShapedModifier,
    Hashable,
    Sendable {

    internal let shape: ShapeToken?

    internal var shapeInsets: SpacingToken? {
        nil
    }
}

extension ClipShapeModifier: TokenViewModifier {

    internal func body(content: Content, theme: TokenTheme) -> some View {
        if let shape = shape?.resolve(for: theme) {
            content.clipShape(shape)
        } else {
            content
        }
    }
}

extension View {

    public nonisolated func clipShape(_ shape: ShapeToken?) -> some View & TokenShapedView {
        modifier(ClipShapeModifier(shape: shape))
    }

    public nonisolated func corners(_ corners: CornersToken?) -> some View & TokenShapedView {
        clipShape(corners.map { .rectangle(corners: $0) })
    }

    public nonisolated func corners(
        radius: CornerRadiusToken?,
        mask: CornersMask = .all
    ) -> some View & TokenShapedView {
        corners(radius.map { CornersToken(radius: $0, mask: mask) })
    }
}
