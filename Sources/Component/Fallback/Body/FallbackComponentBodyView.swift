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
        FallbackComponentBodySize(
            width: fixedWidth,
            height: fixedHeight
        )
    }

    private func sizeWithFixedWidthAndHuggingHeight(
        fixedWidth: CGFloat,
        proposedHeight: CGFloat?
    ) -> FallbackComponentBodySize {
        let targetSize = CGSize(
            width: fixedWidth,
            height: UIView.layoutFittingCompressedSize.height
        )

        let systemLayoutSize = contentView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .almostRequired,
            verticalFittingPriority: .fittingSizeLevel
        )

        let height = proposedHeight?.nonZero.map { proposedHeight in
            min(systemLayoutSize.height, proposedHeight)
        } ?? systemLayoutSize.height

        return FallbackComponentBodySize(
            width: fixedWidth,
            height: height
        )
    }

    private func sizeWithFixedWidthAndFillingHeight(
        fixedWidth: CGFloat,
        proposedHeight: CGFloat?
    ) -> FallbackComponentBodySize {
        let intrinsicSize = CGSize(
            width: fixedWidth,
            height: UIView.noIntrinsicMetric
        )

        let extrinsicSize: CGSize

        switch proposedHeight?.nonZero {
        case nil:
            let targetSize = CGSize(
                width: fixedWidth,
                height: UIView.layoutFittingCompressedSize.height
            )

            extrinsicSize = contentView.systemLayoutSizeFitting(
                targetSize,
                withHorizontalFittingPriority: .almostRequired,
                verticalFittingPriority: .fittingSizeLevel
            )

        case let height?:
            extrinsicSize = CGSize(width: fixedWidth, height: height)
        }

        return FallbackComponentBodySize(
            intrinsic: intrinsicSize,
            extrinsic: extrinsicSize
        )
    }

    private func sizeWithHuggingWidthAndHuggingHeight(
        proposedWidth: CGFloat?,
        proposedHeight: CGFloat?
    ) -> FallbackComponentBodySize {
        var size = contentView.systemLayoutSizeFitting(
            UIView.layoutFittingCompressedSize,
            withHorizontalFittingPriority: .fittingSizeLevel,
            verticalFittingPriority: .fittingSizeLevel
        )

        if let proposedWidth = proposedWidth?.nonZero, proposedWidth < size.width {
            let targetSize = CGSize(
                width: proposedWidth,
                height: UIView.layoutFittingCompressedSize.height
            )

            let systemLayoutSize = contentView.systemLayoutSizeFitting(
                targetSize,
                withHorizontalFittingPriority: .almostRequired,
                verticalFittingPriority: .fittingSizeLevel
            )

            let height = proposedHeight?.nonZero.map { proposedHeight in
                min(systemLayoutSize.height, proposedHeight)
            } ?? systemLayoutSize.height

            size = CGSize(width: proposedWidth, height: height)
        } else if let proposedHeight = proposedHeight?.nonZero, proposedHeight < size.height {
            let targetSize = CGSize(
                width: UIView.layoutFittingCompressedSize.width,
                height: proposedHeight
            )

            let systemLayoutSize = contentView.systemLayoutSizeFitting(
                targetSize,
                withHorizontalFittingPriority: .fittingSizeLevel,
                verticalFittingPriority: .almostRequired
            )

            let width = proposedWidth?.nonZero.map { proposedWidth in
                min(systemLayoutSize.width, proposedWidth)
            } ?? systemLayoutSize.width

            size = CGSize(width: width, height: proposedHeight)
        }

        return FallbackComponentBodySize(size: size)
    }

    private func sizeWithHuggingWidthAndFixedHeight(
        proposedWidth: CGFloat?,
        fixedHeight: CGFloat
    ) -> FallbackComponentBodySize {
        let targetSize = CGSize(
            width: UIView.layoutFittingCompressedSize.width,
            height: fixedHeight
        )

        let systemLayoutSize = contentView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .fittingSizeLevel,
            verticalFittingPriority: .almostRequired
        )

        let width = proposedWidth?.nonZero.map { proposedWidth in
            min(systemLayoutSize.width, proposedWidth)
        } ?? systemLayoutSize.width

        return FallbackComponentBodySize(
            width: width,
            height: fixedHeight
        )
    }

    private func sizeWithHuggingWidthAndFillingHeight(
        proposedWidth: CGFloat?,
        proposedHeight: CGFloat?
    ) -> FallbackComponentBodySize {
        let targetHeight = proposedHeight?.nonZero.map { proposedHeight in
            proposedHeight.isInfinite
                ? UIView.layoutFittingExpandedSize.height
                : proposedHeight
        } ?? UIView.layoutFittingCompressedSize.height

        let targetSize = CGSize(
            width: UIView.layoutFittingCompressedSize.width,
            height: targetHeight
        )

        let systemLayoutSize = contentView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .fittingSizeLevel,
            verticalFittingPriority: proposedHeight?.isNormal == true
                ? .almostRequired
                : .fittingSizeLevel
        )

        let extrinsicSize: CGSize

        if let proposedWidth = proposedWidth?.nonZero, proposedWidth < systemLayoutSize.width {
            if let proposedHeight = proposedHeight?.nonZero {
                extrinsicSize = CGSize(width: proposedWidth, height: proposedHeight)
            } else {
                let systemLayoutSize = contentView.systemLayoutSizeFitting(
                    CGSize(width: proposedWidth, height: targetHeight),
                    withHorizontalFittingPriority: .almostRequired,
                    verticalFittingPriority: .fittingSizeLevel
                )

                extrinsicSize = CGSize(
                    width: proposedWidth,
                    height: systemLayoutSize.height
                )
            }
        } else {
            extrinsicSize = CGSize(
                width: systemLayoutSize.width,
                height: proposedHeight?.nonZero ?? systemLayoutSize.height
            )
        }

        let intrinsicSize = CGSize(
            width: extrinsicSize.width,
            height: UIView.noIntrinsicMetric
        )

        return FallbackComponentBodySize(
            intrinsic: intrinsicSize,
            extrinsic: extrinsicSize
        )
    }

    private func sizeWithFillingWidthAndFillingHeight(
        proposedWidth: CGFloat?,
        proposedHeight: CGFloat?
    ) -> FallbackComponentBodySize {
        let intrinsicSize = CGSize(
            width: UIView.noIntrinsicMetric,
            height: UIView.noIntrinsicMetric
        )

        let extrinsicSize: CGSize

        switch (proposedWidth?.nonZero, proposedHeight?.nonZero) {
        case (nil, nil):
            extrinsicSize = contentView.systemLayoutSizeFitting(
                UIView.layoutFittingCompressedSize,
                withHorizontalFittingPriority: .fittingSizeLevel,
                verticalFittingPriority: .fittingSizeLevel
            )

        case let (width?, nil):
            let targetSize = CGSize(
                width: width,
                height: UIView.layoutFittingCompressedSize.height
            )

            let systemLayoutSize = contentView.systemLayoutSizeFitting(
                targetSize,
                withHorizontalFittingPriority: .almostRequired,
                verticalFittingPriority: .fittingSizeLevel
            )

            extrinsicSize = CGSize(
                width: width,
                height: systemLayoutSize.height
            )

        case let (nil, height?):
            let targetSize = CGSize(
                width: UIView.layoutFittingCompressedSize.width,
                height: height
            )

            let systemLayoutSize = contentView.systemLayoutSizeFitting(
                targetSize,
                withHorizontalFittingPriority: .fittingSizeLevel,
                verticalFittingPriority: .almostRequired
            )

            extrinsicSize = CGSize(
                width: systemLayoutSize.width,
                height: height
            )

        case let (width?, height?):
            extrinsicSize = CGSize(width: width, height: height)
        }

        return FallbackComponentBodySize(
            intrinsic: intrinsicSize,
            extrinsic: extrinsicSize
        )
    }

    private func sizeWithFillingWidthAndFixedHeight(
        proposedWidth: CGFloat?,
        fixedHeight: CGFloat
    ) -> FallbackComponentBodySize {
        let intrinsicSize = CGSize(
            width: UIView.noIntrinsicMetric,
            height: fixedHeight
        )

        let extrinsicSize: CGSize

        switch proposedWidth?.nonZero {
        case nil:
            let targetSize = CGSize(
                width: UIView.layoutFittingCompressedSize.width,
                height: fixedHeight
            )

            extrinsicSize = contentView.systemLayoutSizeFitting(
                targetSize,
                withHorizontalFittingPriority: .fittingSizeLevel,
                verticalFittingPriority: .almostRequired
            )

        case let width?:
            extrinsicSize = CGSize(width: width, height: fixedHeight)
        }

        return FallbackComponentBodySize(
            intrinsic: intrinsicSize,
            extrinsic: extrinsicSize
        )
    }

    private func sizeWithFillingWidthAndHuggingHeight(
        proposedWidth: CGFloat?,
        proposedHeight: CGFloat?
    ) -> FallbackComponentBodySize {
        let targetWidth = proposedWidth?.nonZero.map { proposedWidth in
            proposedWidth.isInfinite
                ? UIView.layoutFittingExpandedSize.width
                : proposedWidth
        } ?? UIView.layoutFittingCompressedSize.width

        let targetSize = CGSize(
            width: targetWidth,
            height: UIView.layoutFittingCompressedSize.height
        )

        let systemLayoutSize = contentView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: proposedWidth?.isNormal == true
                ? .almostRequired
                : .fittingSizeLevel,
            verticalFittingPriority: .fittingSizeLevel
        )

        let extrinsicSize: CGSize

        if let proposedHeight = proposedHeight?.nonZero, proposedHeight < systemLayoutSize.height {
            if let proposedWidth = proposedWidth?.nonZero {
                extrinsicSize = CGSize(width: proposedWidth, height: proposedHeight)
            } else {
                let systemLayoutSize = contentView.systemLayoutSizeFitting(
                    CGSize(width: targetWidth, height: proposedHeight),
                    withHorizontalFittingPriority: .fittingSizeLevel,
                    verticalFittingPriority: .almostRequired
                )

                extrinsicSize = CGSize(
                    width: systemLayoutSize.width,
                    height: proposedHeight
                )
            }
        } else {
            extrinsicSize = CGSize(
                width: proposedWidth?.nonZero ?? systemLayoutSize.width,
                height: systemLayoutSize.height
            )
        }

        let intrinsicSize = CGSize(
            width: UIView.noIntrinsicMetric,
            height: extrinsicSize.height
        )

        return FallbackComponentBodySize(
            intrinsic: intrinsicSize,
            extrinsic: extrinsicSize
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

        case let (.fixed(fixedWidth), .hug(isHeightBounded)):
            sizeWithFixedWidthAndHuggingHeight(
                fixedWidth: fixedWidth,
                proposedHeight: isHeightBounded ? proposedHeight : nil
            )

        case let (.fixed(fixedWidth), .fill):
            sizeWithFixedWidthAndFillingHeight(
                fixedWidth: fixedWidth,
                proposedHeight: proposedHeight
            )

        case let (.hug(isWidthBounded), .hug(isHeightBounded)):
            sizeWithHuggingWidthAndHuggingHeight(
                proposedWidth: isWidthBounded ? proposedWidth : nil,
                proposedHeight: isHeightBounded ? proposedHeight : nil
            )

        case let (.hug(isWidthBounded), .fixed(fixedHeight)):
            sizeWithHuggingWidthAndFixedHeight(
                proposedWidth: isWidthBounded ? proposedWidth : nil,
                fixedHeight: fixedHeight
            )

        case let (.hug(isWidthBounded), .fill):
            sizeWithHuggingWidthAndFillingHeight(
                proposedWidth: isWidthBounded ? proposedWidth : nil,
                proposedHeight: proposedHeight
            )

        case (.fill, .fill):
            sizeWithFillingWidthAndFillingHeight(
                proposedWidth: proposedWidth,
                proposedHeight: proposedHeight
            )

        case let (.fill, .fixed(fixedHeight)):
            sizeWithFillingWidthAndFixedHeight(
                proposedWidth: proposedWidth,
                fixedHeight: fixedHeight
            )

        case let (.fill, .hug(isHeightBounded)):
            sizeWithFillingWidthAndHuggingHeight(
                proposedWidth: proposedWidth,
                proposedHeight: isHeightBounded ? proposedHeight : nil
            )
        }
    }

    private func size(
        content: Content,
        context: ComponentContext,
        fittingSize: CGSize,
        proposedWidth: CGFloat?,
        proposedHeight: CGFloat?
    ) -> FallbackComponentBodySize {
        let cacheSize = context.fallbackComponentSizeCache?.restoreSize(
            for: content,
            fitting: fittingSize
        )

        if let size = cacheSize {
            return size
        }

        let sizing = content.sizing(
            fitting: fittingSize,
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
            fitting: fittingSize
        )

        return size
    }
}

extension FallbackComponentBodyView {

    internal func layout(proposedWidth: CGFloat?, proposedHeight: CGFloat?) -> CGSize? {
        guard let content, let context else {
            return nil
        }

        let containerSize = context.componentContainerSize ?? UIScreen.main.bounds.size

        let fittingWidth = proposedWidth.map { proposedWidth in
            proposedWidth.isNormal
                ? proposedWidth
                : containerSize.width
        } ?? containerSize.width

        let fittingHeight = proposedHeight.map { proposedHeight in
            proposedHeight.isNormal
                ? proposedHeight
                : containerSize.height
        } ?? containerSize.height

        let fittingSize = CGSize(
            width: fittingWidth,
            height: fittingHeight
        )

        let size = size(
            proposedWidth: proposedWidth,
            proposedHeight: proposedHeight,
            sizing: content.sizing(
                fitting: fittingSize,
                context: context
            )
        )

        contentSize = size

        return size.extrinsic
    }

    internal func update(with content: Content, context: ComponentContext) {
        let cache = context.fallbackComponentSizeCache.value

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

        if contentSize != nil {
            invalidateIntrinsicContentSize()
        }
    }

    internal func dismantle() {
        context?.fallbackComponentViewCache.storeView(self)

        content = nil
        context = nil

        contentSize = nil
    }
}
#endif
