#if canImport(UIKit)
import UIKit

/// Технический UI-контейнер для встраивания UIKit-компонентов в SwiftUI-представление.
///
/// Используется для определения размеров UIKit-компонента и установки их в `intrinsicContentSize`.
///
/// - SeeAlso: ``FallbackComponent``
/// - SeeAlso: ``FallbackComponentView``
public final class FallbackComponentBodyView<Content: FallbackComponent>: UIView {

    private let contentView: Content.UIView

    private var content: Content?
    private var context: ComponentContext?

    public override var canBecomeFirstResponder: Bool {
        contentView.canBecomeFirstResponder
    }

    public override var canResignFirstResponder: Bool {
        contentView.canResignFirstResponder
    }

    public override var isFirstResponder: Bool {
        contentView.isFirstResponder
    }

    public override init(frame: CGRect = .zero) {
        self.contentView = Content.UIView(frame: frame)

        super.init(frame: frame)

        addSubview(contentView)

        contentView.translatesAutoresizingMaskIntoConstraints = false

        contentView
            .topAnchor
            .constraint(equalTo: topAnchor)
            .activate()

        contentView
            .leadingAnchor
            .constraint(equalTo: leadingAnchor)
            .activate()

        contentView
            .bottomAnchor
            .constraint(equalTo: bottomAnchor)
            .priority(.almostRequired)
            .activate()

        contentView
            .trailingAnchor
            .constraint(equalTo: trailingAnchor)
            .priority(.almostRequired)
            .activate()
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @discardableResult
    public override func becomeFirstResponder() -> Bool {
        contentView.becomeFirstResponder()
    }

    @discardableResult
    public override func resignFirstResponder() -> Bool {
        contentView.resignFirstResponder()
    }

    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        contentView.hitTest(point, with: event)
    }

    public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        contentView.point(inside: point, with: event)
    }
}

extension FallbackComponentBodyView {

    // swiftlint:disable:next function_body_length
    private func size(proposedSize: CGSize, sizing: ComponentSizing) -> CGSize {
        switch (sizing.width, sizing.height) {
        case let (.fixed(fixedWidth), .fixed(fixedHeight)):
            contentView.sizeWithFixedWidthAndFixedHeight(
                width: fixedWidth,
                height: fixedHeight
            )

        case let (.fixed(fixedWidth), .hug):
            contentView.sizeWithFixedWidthAndHuggingHeight(
                width: fixedWidth,
                containerHeight: proposedSize.height,
                maxHeight: proposedSize.height
            )

        case let (.fixed(fixedWidth), .fill):
            contentView.sizeWithFixedWidthAndFillingHeight(
                width: fixedWidth,
                containerHeight: proposedSize.height
            )

        case let (.hug, .fixed(fixedHeight)):
            contentView.sizeWithHuggingWidthAndFixedHeight(
                containerWidth: proposedSize.width,
                maxWidth: proposedSize.width,
                height: fixedHeight
            )

        case (.hug, .hug):
            contentView.sizeWithHuggingWidthAndHuggingHeight(
                containerWidth: proposedSize.width,
                maxWidth: proposedSize.width,
                containerHeight: proposedSize.height,
                maxHeight: proposedSize.height
            )

        case (.hug, .fill):
            contentView.sizeWithHuggingWidthAndFillingHeight(
                containerWidth: proposedSize.width,
                maxWidth: proposedSize.width,
                containerHeight: proposedSize.height
            )

        case let (.fill, .fixed(fixedHeight)):
            contentView.sizeWithFillingWidthAndFixedHeight(
                containerWidth: proposedSize.width,
                height: fixedHeight
            )

        case (.fill, .hug):
            contentView.sizeWithFillingWidthAndHuggingHeight(
                containerWidth: proposedSize.width,
                containerHeight: proposedSize.height,
                maxHeight: proposedSize.height
            )

        case (.fill, .fill):
            contentView.sizeWithFillingWidthAndFillingHeight(
                containerWidth: proposedSize.width,
                containerHeight: proposedSize.height
            )
        }
    }

    private func size(
        content: Content,
        context: ComponentContext,
        proposedSize: CGSize,
        boundingSize: CGSize
    ) -> CGSize {
        let cache = context.fallbackComponentCache.value

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

        let size = size(
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

extension FallbackComponentBodyView {

    internal func layout(proposedWidth: CGFloat?, proposedHeight: CGFloat?) -> CGSize? {
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

        return size(
            content: content,
            context: context,
            proposedSize: proposedSize,
            boundingSize: boundingSize
        )
    }

    internal func update(with content: Content, context: ComponentContext) {
        let cache = context.fallbackComponentCache.value

        let contentContext = context.componentLayoutInvalidation { [weak cache] in
            cache?.resetSize(for: content)
        }

        self.content = content
        self.context = contentContext

        tokens.themeKey(context.tokenThemeKey)
        tokens.themeScheme(context.tokenThemeScheme)

        contentView.update(
            with: content,
            context: contentContext
        )
    }
}
#endif
