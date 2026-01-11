#if canImport(UIKit)
import UIKit

public final class FallbackComponentBodyCoordinator<Content: FallbackComponent>: UIViewController {

    private let contentView = Content.UIView()

    private var content: Content?
    private var context: ComponentContext?

    public override func loadView() {
        view = contentView
    }
}

extension FallbackComponentBodyCoordinator {

    // swiftlint:disable:next function_body_length
    private func sizeThatFits(proposedSize: CGSize, sizing: ComponentSizing) -> CGSize {
        switch (sizing.width, sizing.height) {
        case let (.fixed(fixedWidth), .fixed(fixedHeight)):
            view.sizeWithFixedWidthAndFixedHeight(
                width: fixedWidth,
                height: fixedHeight
            )

        case let (.fixed(fixedWidth), .hug):
            view.sizeWithFixedWidthAndHuggingHeight(
                width: fixedWidth,
                containerHeight: proposedSize.height,
                maxHeight: proposedSize.height
            )

        case let (.fixed(fixedWidth), .fill):
            view.sizeWithFixedWidthAndFillingHeight(
                width: fixedWidth,
                containerHeight: proposedSize.height
            )

        case let (.hug, .fixed(fixedHeight)):
            view.sizeWithHuggingWidthAndFixedHeight(
                containerWidth: proposedSize.width,
                maxWidth: proposedSize.width,
                height: fixedHeight
            )

        case (.hug, .hug):
            view.sizeWithHuggingWidthAndHuggingHeight(
                containerWidth: proposedSize.width,
                maxWidth: proposedSize.width,
                containerHeight: proposedSize.height,
                maxHeight: proposedSize.height
            )

        case (.hug, .fill):
            view.sizeWithHuggingWidthAndFillingHeight(
                containerWidth: proposedSize.width,
                maxWidth: proposedSize.width,
                containerHeight: proposedSize.height
            )

        case let (.fill, .fixed(fixedHeight)):
            view.sizeWithFillingWidthAndFixedHeight(
                containerWidth: proposedSize.width,
                height: fixedHeight
            )

        case (.fill, .hug):
            view.sizeWithFillingWidthAndHuggingHeight(
                containerWidth: proposedSize.width,
                containerHeight: proposedSize.height,
                maxHeight: proposedSize.height
            )

        case (.fill, .fill):
            view.sizeWithFillingWidthAndFillingHeight(
                containerWidth: proposedSize.width,
                containerHeight: proposedSize.height
            )
        }
    }

    private func sizeThatFits(
        content: Content,
        context: ComponentContext,
        proposedSize: CGSize,
        boundingSize: CGSize
    ) -> CGSize {
        let cache = context
            .fallbackComponentCache
            .value

        let cacheSize = cache?.restoreSize(
            for: content,
            proposedSize: proposedSize,
            boundingSize: boundingSize
        )

        if let size = cacheSize {
            return size
        }

        let sizing = content.sizing(
            fitting: boundingSize,
            context: context
        )

        let size = sizeThatFits(
            proposedSize: proposedSize,
            sizing: sizing
        )

        cache?.storeSize(
            for: content,
            size: size,
            sizing: sizing,
            proposedSize: proposedSize,
            boundingSize: boundingSize
        )

        return size
    }
}

extension FallbackComponentBodyCoordinator {

    internal func sizeThatFits(proposedWidth: CGFloat?, proposedHeight: CGFloat?) -> CGSize? {
        guard let content, let context else {
            return nil
        }

        // Считаем идеальные размеры как минимальные
        let proposedSize = CGSize(
            width: proposedWidth ?? .zero,
            height: proposedHeight ?? .zero
        )

        // Для получения идеальных размеров не ограничиваем стратегии
        let boundingSize = CGSize(
            width: proposedWidth ?? .infinity,
            height: proposedHeight ?? .infinity
        )

        return sizeThatFits(
            content: content,
            context: context,
            proposedSize: proposedSize,
            boundingSize: boundingSize
        )
    }

    internal func update(content: Content, context: ComponentContext) {
        let cache = context.fallbackComponentCache.value
        let theme = context.tokenTheme

        let context = context
            .componentViewController(self)
            .componentLayoutInvalidation { [weak cache] in
                cache?.resetSize(for: content)
            }

        self.content = content
        self.context = context

        tokens.themeKey(theme.key)
        tokens.themeScheme(theme.scheme)

        contentView.update(
            with: content,
            context: context
        )
    }
}
#endif
