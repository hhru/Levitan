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

    private var contentSize: CGSize?

    public override var intrinsicContentSize: CGSize {
        contentSize ?? super.intrinsicContentSize
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

    private func layoutWithFixedSize(fixedWidth: CGFloat, fixedHeight: CGFloat) -> CGSize {
        let size = CGSize(width: fixedWidth, height: fixedHeight)

        contentSize = size

        return size
    }

    private func layoutWithFixedWidthAndHuggingHeight(fixedWidth: CGFloat, proposedHeight: CGFloat?) -> CGSize {
        let targetSize = CGSize(
            width: fixedWidth,
            height: UIView.layoutFittingCompressedSize.height
        )

        let intrinsicSize = contentView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .almostRequired,
            verticalFittingPriority: .fittingSizeLevel
        )

        let height = proposedHeight?.nonZero.map { proposedHeight in
            min(intrinsicSize.height, proposedHeight)
        } ?? intrinsicSize.height

        let size = CGSize(width: fixedWidth, height: height)

        contentSize = size

        return size
    }

    private func layoutWithFixedWidthAndFillingHeight(fixedWidth: CGFloat, proposedHeight: CGFloat?) -> CGSize {
        contentSize = CGSize(
            width: fixedWidth,
            height: UIView.noIntrinsicMetric
        )

        switch proposedHeight?.nonZero {
        case nil:
            let targetSize = CGSize(
                width: fixedWidth,
                height: UIView.layoutFittingCompressedSize.height
            )

            return contentView.systemLayoutSizeFitting(
                targetSize,
                withHorizontalFittingPriority: .almostRequired,
                verticalFittingPriority: .fittingSizeLevel
            )

        case let height?:
            return CGSize(width: fixedWidth, height: height)
        }
    }

    private func layoutWithHuggingSize(proposedWidth: CGFloat?, proposedHeight: CGFloat?) -> CGSize {
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

            let intrinsicSize = contentView.systemLayoutSizeFitting(
                targetSize,
                withHorizontalFittingPriority: .almostRequired,
                verticalFittingPriority: .fittingSizeLevel
            )

            let height = proposedHeight?.nonZero.map { proposedHeight in
                min(intrinsicSize.height, proposedHeight)
            } ?? intrinsicSize.height

            size = CGSize(width: proposedWidth, height: height)
        } else if let proposedHeight = proposedHeight?.nonZero, proposedHeight < size.height {
            let targetSize = CGSize(
                width: UIView.layoutFittingCompressedSize.width,
                height: proposedHeight
            )

            let intrinsicSize = contentView.systemLayoutSizeFitting(
                targetSize,
                withHorizontalFittingPriority: .fittingSizeLevel,
                verticalFittingPriority: .almostRequired
            )

            let width = proposedWidth?.nonZero.map { proposedWidth in
                min(intrinsicSize.width, proposedWidth)
            } ?? intrinsicSize.width

            size = CGSize(width: width, height: proposedHeight)
        }

        contentSize = size

        return size
    }

    private func layoutWithHuggingWidthAndFixedHeight(proposedWidth: CGFloat?, fixedHeight: CGFloat) -> CGSize {
        let targetSize = CGSize(
            width: UIView.layoutFittingCompressedSize.width,
            height: fixedHeight
        )

        let intrinsicSize = contentView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .fittingSizeLevel,
            verticalFittingPriority: .almostRequired
        )

        let width = proposedWidth?.nonZero.map { proposedWidth in
            min(intrinsicSize.width, proposedWidth)
        } ?? intrinsicSize.width

        let size = CGSize(width: width, height: fixedHeight)

        contentSize = size

        return size
    }

    private func layoutWithHuggingWidthAndFillingHeight(proposedWidth: CGFloat?, proposedHeight: CGFloat?) -> CGSize {
        let targetHeight = proposedHeight?.nonZero.map { proposedHeight in
            proposedHeight.isInfinite
                ? UIView.layoutFittingExpandedSize.height
                : proposedHeight
        } ?? UIView.layoutFittingCompressedSize.height

        let targetSize = CGSize(
            width: UIView.layoutFittingCompressedSize.width,
            height: targetHeight
        )

        let intrinsicSize = contentView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .fittingSizeLevel,
            verticalFittingPriority: proposedHeight?.isNormal == true
                ? .almostRequired
                : .fittingSizeLevel
        )

        let size: CGSize

        if let proposedWidth = proposedWidth?.nonZero, proposedWidth < intrinsicSize.width {
            if let proposedHeight = proposedHeight?.nonZero {
                size = CGSize(width: proposedWidth, height: proposedHeight)
            } else {
                let intrinsicSize = contentView.systemLayoutSizeFitting(
                    CGSize(width: proposedWidth, height: targetHeight),
                    withHorizontalFittingPriority: .almostRequired,
                    verticalFittingPriority: .fittingSizeLevel
                )

                size = CGSize(
                    width: proposedWidth,
                    height: intrinsicSize.height
                )
            }
        } else {
            size = CGSize(
                width: intrinsicSize.width,
                height: proposedHeight?.nonZero ?? intrinsicSize.height
            )
        }

        contentSize = CGSize(
            width: size.width,
            height: UIView.noIntrinsicMetric
        )

        return size
    }

    private func layoutWithFillingSize(proposedWidth: CGFloat?, proposedHeight: CGFloat?) -> CGSize {
        contentSize = CGSize(
            width: UIView.noIntrinsicMetric,
            height: UIView.noIntrinsicMetric
        )

        switch (proposedWidth?.nonZero, proposedHeight?.nonZero) {
        case (nil, nil):
            return contentView.systemLayoutSizeFitting(
                UIView.layoutFittingCompressedSize,
                withHorizontalFittingPriority: .fittingSizeLevel,
                verticalFittingPriority: .fittingSizeLevel
            )

        case let (width?, nil):
            let targetSize = CGSize(
                width: width,
                height: UIView.layoutFittingCompressedSize.height
            )

            let intrinsicSize = contentView.systemLayoutSizeFitting(
                targetSize,
                withHorizontalFittingPriority: .almostRequired,
                verticalFittingPriority: .fittingSizeLevel
            )

            return CGSize(
                width: width,
                height: intrinsicSize.height
            )

        case let (nil, height?):
            let targetSize = CGSize(
                width: UIView.layoutFittingCompressedSize.width,
                height: height
            )

            let intrinsicSize = contentView.systemLayoutSizeFitting(
                targetSize,
                withHorizontalFittingPriority: .fittingSizeLevel,
                verticalFittingPriority: .almostRequired
            )

            return CGSize(
                width: intrinsicSize.width,
                height: height
            )

        case let (width?, height?):
            return CGSize(width: width, height: height)
        }
    }

    private func layoutWithFillingWidthAndFixedHeight(proposedWidth: CGFloat?, fixedHeight: CGFloat) -> CGSize {
        contentSize = CGSize(
            width: UIView.noIntrinsicMetric,
            height: fixedHeight
        )

        switch proposedWidth?.nonZero {
        case nil:
            let targetSize = CGSize(
                width: UIView.layoutFittingCompressedSize.width,
                height: fixedHeight
            )

            return contentView.systemLayoutSizeFitting(
                targetSize,
                withHorizontalFittingPriority: .fittingSizeLevel,
                verticalFittingPriority: .almostRequired
            )

        case let width?:
            return CGSize(width: width, height: fixedHeight)
        }
    }

    private func layoutWithFillingWidthAndHuggingHeight(proposedWidth: CGFloat?, proposedHeight: CGFloat?) -> CGSize {
        let targetWidth = proposedWidth?.nonZero.map { proposedWidth in
            proposedWidth.isInfinite
                ? UIView.layoutFittingExpandedSize.width
                : proposedWidth
        } ?? UIView.layoutFittingCompressedSize.width

        let targetSize = CGSize(
            width: targetWidth,
            height: UIView.layoutFittingCompressedSize.height
        )

        let intrinsicSize = contentView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: proposedWidth?.isNormal == true
                ? .almostRequired
                : .fittingSizeLevel,
            verticalFittingPriority: .fittingSizeLevel
        )

        let size: CGSize

        if let proposedHeight = proposedHeight?.nonZero, proposedHeight < intrinsicSize.height {
            if let proposedWidth = proposedWidth?.nonZero {
                size = CGSize(width: proposedWidth, height: proposedHeight)
            } else {
                let intrinsicSize = contentView.systemLayoutSizeFitting(
                    CGSize(width: targetWidth, height: proposedHeight),
                    withHorizontalFittingPriority: .fittingSizeLevel,
                    verticalFittingPriority: .almostRequired
                )

                size = CGSize(
                    width: intrinsicSize.width,
                    height: proposedHeight
                )
            }
        } else {
            size = CGSize(
                width: proposedWidth?.nonZero ?? intrinsicSize.width,
                height: intrinsicSize.height
            )
        }

        contentSize = CGSize(
            width: UIView.noIntrinsicMetric,
            height: size.height
        )

        return size
    }

    private func layout(proposedWidth: CGFloat?, proposedHeight: CGFloat?, sizing: ComponentSizing) -> CGSize {
        switch (sizing.width, sizing.height) {
        case let (.fixed(fixedWidth), .fixed(fixedHeight)):
            return layoutWithFixedSize(
                fixedWidth: fixedWidth,
                fixedHeight: fixedHeight
            )

        case let (.fixed(fixedWidth), .hug(isHeightBounded)):
            return layoutWithFixedWidthAndHuggingHeight(
                fixedWidth: fixedWidth,
                proposedHeight: isHeightBounded ? proposedHeight : nil
            )

        case let (.fixed(fixedWidth), .fill):
            return layoutWithFixedWidthAndFillingHeight(
                fixedWidth: fixedWidth,
                proposedHeight: proposedHeight
            )

        case let (.hug(isWidthBounded), .hug(isHeightBounded)):
            return layoutWithHuggingSize(
                proposedWidth: isWidthBounded ? proposedWidth : nil,
                proposedHeight: isHeightBounded ? proposedHeight : nil
            )

        case let (.hug(isWidthBounded), .fixed(fixedHeight)):
            return layoutWithHuggingWidthAndFixedHeight(
                proposedWidth: isWidthBounded ? proposedWidth : nil,
                fixedHeight: fixedHeight
            )

        case let (.hug(isWidthBounded), .fill):
            return layoutWithHuggingWidthAndFillingHeight(
                proposedWidth: isWidthBounded ? proposedWidth : nil,
                proposedHeight: proposedHeight
            )

        case (.fill, .fill):
            return layoutWithFillingSize(
                proposedWidth: proposedWidth,
                proposedHeight: proposedHeight
            )

        case let (.fill, .fixed(fixedHeight)):
            return layoutWithFillingWidthAndFixedHeight(
                proposedWidth: proposedWidth,
                fixedHeight: fixedHeight
            )

        case let (.fill, .hug(isHeightBounded)):
            return layoutWithFillingWidthAndHuggingHeight(
                proposedWidth: proposedWidth,
                proposedHeight: isHeightBounded ? proposedHeight : nil
            )
        }
    }
}

extension FallbackComponentBodyView {

    internal func layout(proposedWidth: CGFloat?, proposedHeight: CGFloat?) -> CGSize? {
        guard let content, let context else {
            return nil
        }

        let containerSize = context.componentContainerSize.value ?? UIScreen.main.bounds.size

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

        let sizing = content.sizing(
            fitting: fittingSize,
            context: context
        )

        return layout(
            proposedWidth: proposedWidth,
            proposedHeight: proposedHeight,
            sizing: sizing
        )
    }

    internal func update(with content: Content, context: ComponentContext) {
        self.content = content
        self.context = context

        tokens.themeKey(context.tokenThemeKey)
        tokens.themeScheme(context.tokenThemeScheme)

        contentView.update(
            with: content,
            context: context
        )

        if contentSize != nil {
            invalidateIntrinsicContentSize()
        }
    }
}
#endif
