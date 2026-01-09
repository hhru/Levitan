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

    private var contentSize: FallbackComponentBodySize?

    public override var intrinsicContentSize: CGSize {
        contentSize?.intrinsic ?? super.intrinsicContentSize
    }

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

        setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        setContentCompressionResistancePriority(.defaultHigh, for: .vertical)

        setContentHuggingPriority(.defaultHigh, for: .horizontal)
        setContentHuggingPriority(.defaultHigh, for: .vertical)

        setupContentView()
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

    private func setupContentView() {
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

    private func sizeWithFixedWidthAndFixedHeight(
        fixedWidth: CGFloat,
        fixedHeight: CGFloat
    ) -> FallbackComponentBodySize {
        let size = contentView.sizeWithFixedWidthAndFixedHeight(
            width: fixedWidth,
            height: fixedHeight
        )

        return FallbackComponentBodySize(size: size)
    }

    private func sizeWithFixedWidthAndHuggingHeight(
        fixedWidth: CGFloat,
        proposedHeight: CGFloat?
    ) -> FallbackComponentBodySize {
        let size = contentView.sizeWithFixedWidthAndHuggingHeight(
            width: fixedWidth,
            containerHeight: proposedHeight,
            maxHeight: proposedHeight
        )

        return FallbackComponentBodySize(size: size)
    }

    private func sizeWithFixedWidthAndFillingHeight(
        fixedWidth: CGFloat,
        proposedHeight: CGFloat?
    ) -> FallbackComponentBodySize {
        let extrinsicSize = contentView.sizeWithFixedWidthAndFillingHeight(
            width: fixedWidth,
            containerHeight: proposedHeight
        )

        let intrinsicSize = CGSize(
            width: fixedWidth,
            height: UIView.noIntrinsicMetric
        )

        return FallbackComponentBodySize(
            extrinsic: extrinsicSize,
            intrinsic: intrinsicSize
        )
    }

    private func sizeWithHuggingWidthAndFixedHeight(
        proposedWidth: CGFloat?,
        fixedHeight: CGFloat
    ) -> FallbackComponentBodySize {
        let size = contentView.sizeWithHuggingWidthAndFixedHeight(
            containerWidth: proposedWidth,
            maxWidth: proposedWidth,
            height: fixedHeight
        )

        return FallbackComponentBodySize(size: size)
    }

    private func sizeWithHuggingWidthAndHuggingHeight(
        proposedWidth: CGFloat?,
        proposedHeight: CGFloat?
    ) -> FallbackComponentBodySize {
        let size = contentView.sizeWithHuggingWidthAndHuggingHeight(
            containerWidth: proposedWidth,
            maxWidth: proposedWidth,
            containerHeight: proposedHeight,
            maxHeight: proposedHeight
        )

        return FallbackComponentBodySize(size: size)
    }

    private func sizeWithHuggingWidthAndFillingHeight(
        proposedWidth: CGFloat?,
        proposedHeight: CGFloat?
    ) -> FallbackComponentBodySize {
        let extrinsicSize = contentView.sizeWithHuggingWidthAndFillingHeight(
            containerWidth: proposedWidth,
            maxWidth: proposedWidth,
            containerHeight: proposedHeight
        )

        let intrinsicSize = CGSize(
            width: extrinsicSize.width,
            height: UIView.noIntrinsicMetric
        )

        return FallbackComponentBodySize(
            extrinsic: extrinsicSize,
            intrinsic: intrinsicSize
        )
    }

    private func sizeWithFillingWidthAndFixedHeight(
        proposedWidth: CGFloat?,
        fixedHeight: CGFloat
    ) -> FallbackComponentBodySize {
        let extrinsicSize = contentView.sizeWithFillingWidthAndFixedHeight(
            containerWidth: proposedWidth,
            height: fixedHeight
        )

        let intrinsicSize = CGSize(
            width: UIView.noIntrinsicMetric,
            height: fixedHeight
        )

        return FallbackComponentBodySize(
            extrinsic: extrinsicSize,
            intrinsic: intrinsicSize
        )
    }

    private func sizeWithFillingWidthAndHuggingHeight(
        proposedWidth: CGFloat?,
        proposedHeight: CGFloat?
    ) -> FallbackComponentBodySize {
        let extrinsicSize = contentView.sizeWithFillingWidthAndHuggingHeight(
            containerWidth: proposedWidth,
            containerHeight: proposedHeight,
            maxHeight: proposedHeight
        )

        let intrinsicSize = CGSize(
            width: UIView.noIntrinsicMetric,
            height: extrinsicSize.height
        )

        return FallbackComponentBodySize(
            extrinsic: extrinsicSize,
            intrinsic: intrinsicSize
        )
    }

    private func sizeWithFillingWidthAndFillingHeight(
        proposedWidth: CGFloat?,
        proposedHeight: CGFloat?
    ) -> FallbackComponentBodySize {
        let extrinsicSize = contentView.sizeWithFillingWidthAndFillingHeight(
            containerWidth: proposedWidth,
            containerHeight: proposedHeight
        )

        let intrinsicSize = CGSize(
            width: UIView.noIntrinsicMetric,
            height: UIView.noIntrinsicMetric
        )

        return FallbackComponentBodySize(
            extrinsic: extrinsicSize,
            intrinsic: intrinsicSize
        )
    }

    private func size(
        proposedWidth: CGFloat?,
        proposedHeight: CGFloat?,
        sizing: ComponentSizing
    ) -> FallbackComponentBodySize {
        switch (sizing.width, sizing.height) {
        case let (.fixed(fixedWidth), .fixed(fixedHeight)):
            sizeWithFixedWidthAndFixedHeight(
                fixedWidth: fixedWidth,
                fixedHeight: fixedHeight
            )

        case let (.fixed(fixedWidth), .hug):
            sizeWithFixedWidthAndHuggingHeight(
                fixedWidth: fixedWidth,
                proposedHeight: proposedHeight
            )

        case let (.fixed(fixedWidth), .fill):
            sizeWithFixedWidthAndFillingHeight(
                fixedWidth: fixedWidth,
                proposedHeight: proposedHeight
            )

        case let (.hug, .fixed(fixedHeight)):
            sizeWithHuggingWidthAndFixedHeight(
                proposedWidth: proposedWidth,
                fixedHeight: fixedHeight
            )

        case (.hug, .hug):
            sizeWithHuggingWidthAndHuggingHeight(
                proposedWidth: proposedWidth,
                proposedHeight: proposedHeight
            )

        case (.hug, .fill):
            sizeWithHuggingWidthAndFillingHeight(
                proposedWidth: proposedWidth,
                proposedHeight: proposedHeight
            )

        case let (.fill, .fixed(fixedHeight)):
            sizeWithFillingWidthAndFixedHeight(
                proposedWidth: proposedWidth,
                fixedHeight: fixedHeight
            )

        case (.fill, .hug):
            sizeWithFillingWidthAndHuggingHeight(
                proposedWidth: proposedWidth,
                proposedHeight: proposedHeight
            )

        case (.fill, .fill):
            sizeWithFillingWidthAndFillingHeight(
                proposedWidth: proposedWidth,
                proposedHeight: proposedHeight
            )
        }
    }

    private func size(
        content: Content,
        context: ComponentContext,
        containerSize: CGSize,
        proposedWidth: CGFloat?,
        proposedHeight: CGFloat?
    ) -> FallbackComponentBodySize {
        Logger.debug(
            ["\(Self.self).\(#function)"],
            ["id:", context.componentIdentifier?.value ?? "nil"],
            ["containerSize:", containerSize],
            ["proposalWidth:", proposedWidth ?? "nil"],
            ["proposalHeight:", proposedHeight ?? "nil"],
            subsystem: "Component",
            category: "FallbackComponentBodyView"
        )

        let cacheSize = context
            .fallbackComponentSizeCache?
            .restoreSize(for: content, fitting: containerSize)

        if let size = cacheSize {
            return size
        }

        let sizing = content.sizing(
            fitting: containerSize,
            context: context
        )

        let size = size(
            proposedWidth: proposedWidth,
            proposedHeight: proposedHeight,
            sizing: sizing
        )

        context.fallbackComponentSizeCache?.storeSize(
            size,
            for: content,
            fitting: containerSize
        )

        Logger.debug(
            ["\(Self.self).\(#function) -- END"],
            ["size:", size.extrinsic],
            subsystem: "Component",
            category: "FallbackComponentBodyView"
        )

        return size
    }
}

extension FallbackComponentBodyView {

    internal func layout(proposedWidth: CGFloat?, proposedHeight: CGFloat?) -> CGSize? {
        Logger.debug(
            ["\(Self.self).\(#function)"],
            ["id:", context?.componentIdentifier?.value ?? "nil"],
            ["proposalWidth:", proposedWidth ?? "nil"],
            ["proposalHeight:", proposedHeight ?? "nil"],
            subsystem: "Component",
            category: "FallbackComponentBodyView"
        )

        guard let content, let context else {
            return contentSize?.extrinsic
        }

        let contextContainerSize = context.componentContainerSize ?? UIScreen.main.bounds.size

        let containerSize = CGSize(
            width: proposedWidth ?? contextContainerSize.width,
            height: proposedHeight ?? contextContainerSize.height
        )

        let size = size(
            content: content,
            context: context,
            containerSize: containerSize,
            proposedWidth: proposedWidth,
            proposedHeight: proposedHeight
        )

        contentSize = size

        return size.extrinsic
    }

    internal func update(with content: Content, context: ComponentContext) {
        Logger.debug(
            ["\(Self.self).\(#function)"],
            ["id:", context.componentIdentifier?.value ?? "nil"],
            subsystem: "Component",
            category: "FallbackComponentBodyView"
        )

        let cache = context.fallbackComponentSizeCache.value

        let contentContext = context.componentLayoutInvalidation { [weak self, weak cache] in
            self?.invalidateIntrinsicContentSize()
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

        if contentSize != nil {
            invalidateIntrinsicContentSize()
        }
    }
}
#endif
