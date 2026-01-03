#if canImport(UIKit)
import Foundation

extension PaddingModifier: ComponentTokenModifier
where Content: Component {

    internal func sizing(
        content: Content,
        fitting size: CGSize,
        context: ComponentContext
    ) -> ComponentSizing {
        let sizing = content.sizing(
            fitting: size,
            context: context
        )

        guard let insets = insets?.resolve(for: context.tokenTheme) else {
            return sizing
        }

        switch (sizing.width, sizing.height) {
        case let (.fixed(width), .fixed(height)):
            return ComponentSizing(
                width: .fixed(width + insets.horizontal),
                height: .fixed(height + insets.vertical)
            )

        case let (.fixed(width), height):
            return ComponentSizing(
                width: .fixed(width + insets.horizontal),
                height: height
            )

        case let (width, .fixed(height)):
            return ComponentSizing(
                width: width,
                height: .fixed(height + insets.vertical)
            )

        default:
            return sizing
        }
    }
}

extension Component {

    public nonisolated func padding(_ insets: InsetsToken?) -> some Component {
        modifier(PaddingModifier(insets: insets))
    }

    public nonisolated func padding(
        top: SpacingToken = .zero,
        leading: SpacingToken = .zero,
        bottom: SpacingToken = .zero,
        trailing: SpacingToken = .zero
    ) -> some Component {
        padding(
            InsetsToken(
                top: top,
                leading: leading,
                bottom: bottom,
                trailing: trailing
            )
        )
    }

    public nonisolated func padding(_ edge: InsetsEdge, _ value: SpacingToken) -> some Component {
        padding(InsetsToken(edge, value))
    }

    public nonisolated func padding(all spacing: SpacingToken?) -> some Component {
        padding(spacing.map(InsetsToken.init(all:)))
    }
}
#endif
