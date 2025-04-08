#if canImport(UIKit)
import UIKit

open class AnyListCell: UICollectionViewCell {

    public typealias Deselection = (_ animated: Bool) -> Void

    open class var reuseIdentifier: String {
        "\(Self.self)"
    }

    open func onSelect(deselection: Deselection) { }
    open func onDeselect() { }

    open func onAppear() { }
    open func onDisappear() { }

    public final override func preferredLayoutAttributesFitting(
        _ layoutAttributes: UICollectionViewLayoutAttributes
    ) -> UICollectionViewLayoutAttributes {
        guard let layoutAttributes = layoutAttributes as? CollectionViewLayoutAttributes else {
            return super.preferredLayoutAttributesFitting(layoutAttributes)
        }

        guard let sizing = layoutAttributes.sizing else {
            return layoutAttributes
        }

        layoutAttributes.size = size(for: sizing)

        return layoutAttributes
    }

    private func size(for sizing: CollectionViewLayoutSizing) -> CGSize {
        switch (sizing.width, sizing.height) {
        case let (.fixed(fixedWidth), .fixed(fixedHeight)):
            return sizeWithFixedWidthAndFixedHeight(
                fixedWidth: fixedWidth,
                fixedHeight: fixedHeight
            )

        case let (.fixed(fixedWidth), .hug(isHeightBounded)):
            return sizeWithFixedWidthAndHuggingHeight(
                fixedWidth: fixedWidth,
                containerHeight: isHeightBounded ? sizing.proposedSize.height : nil
            )

        case let (.fixed(fixedWidth), .fill):
            return sizeWithFixedWidthAndFillingHeight(
                fixedWidth: fixedWidth,
                containerHeight: sizing.proposedSize.height
            )

        case let (.hug(isWidthBounded), .hug(isHeightBounded)):
            return sizeWithHuggingWidthAndHuggingHeight(
                containerWidth: isWidthBounded ? sizing.proposedSize.width : nil,
                containerHeight: isHeightBounded ? sizing.proposedSize.height : nil
            )

        case let (.hug(isWidthBounded), .fixed(fixedHeight)):
            return sizeWithHuggingWidthAndFixedHeight(
                containerWidth: isWidthBounded ? sizing.proposedSize.width : nil,
                fixedHeight: fixedHeight
            )

        case let (.hug(isWidthBounded), .fill):
            return sizeWithHuggingWidthAndFillingHeight(
                containerWidth: isWidthBounded ? sizing.proposedSize.width : nil,
                containerHeight: sizing.proposedSize.height
            )

        case (.fill, .fill):
            return sizeWithFillingWidthAndFillingHeight(
                containerWidth: sizing.proposedSize.width,
                containerHeight: sizing.proposedSize.height
            )

        case let (.fill, .fixed(fixedHeight)):
            return sizeWithFillingWidthAndFixedHeight(
                containerWidth: sizing.proposedSize.width,
                fixedHeight: fixedHeight
            )

        case let (.fill, .hug(isHeightBounded)):
            return sizeWithFillingWidthAndHuggingHeight(
                containerWidth: sizing.proposedSize.width,
                containerHeight: isHeightBounded ? sizing.proposedSize.height : nil
            )
        }
    }

    private func sizeWithFixedWidthAndFixedHeight(fixedWidth: CGFloat, fixedHeight: CGFloat) -> CGSize {
        CGSize(
            width: fixedWidth,
            height: fixedHeight
        )
    }

    private func sizeWithFixedWidthAndHuggingHeight(fixedWidth: CGFloat, containerHeight: CGFloat?) -> CGSize {
        let targetSize = CGSize(
            width: fixedWidth,
            height: UIView.layoutFittingCompressedSize.height
        )

        let intrinsicSize = contentView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .almostRequired,
            verticalFittingPriority: .fittingSizeLevel
        )

        let height = containerHeight.map { containerHeight in
            min(intrinsicSize.height, containerHeight)
        } ?? intrinsicSize.height

        return CGSize(
            width: fixedWidth,
            height: height
        )
    }

    private func sizeWithFixedWidthAndFillingHeight(fixedWidth: CGFloat, containerHeight: CGFloat) -> CGSize {
        CGSize(width: fixedWidth, height: containerHeight)
    }

    private func sizeWithHuggingWidthAndHuggingHeight(containerWidth: CGFloat?, containerHeight: CGFloat?) -> CGSize {
        let intrinsicSize = contentView.systemLayoutSizeFitting(
            UIView.layoutFittingCompressedSize,
            withHorizontalFittingPriority: .fittingSizeLevel,
            verticalFittingPriority: .fittingSizeLevel
        )

        if let containerWidth, containerWidth < intrinsicSize.width {
            let targetSize = CGSize(
                width: containerWidth,
                height: UIView.layoutFittingCompressedSize.height
            )

            let intrinsicSize = contentView.systemLayoutSizeFitting(
                targetSize,
                withHorizontalFittingPriority: .almostRequired,
                verticalFittingPriority: .fittingSizeLevel
            )

            let height = containerHeight.map { containerHeight in
                min(intrinsicSize.height, containerHeight)
            } ?? intrinsicSize.height

            return CGSize(
                width: containerWidth,
                height: height
            )
        }

        if let containerHeight, containerHeight < intrinsicSize.height {
            let targetSize = CGSize(
                width: UIView.layoutFittingCompressedSize.width,
                height: containerHeight
            )

            let intrinsicSize = contentView.systemLayoutSizeFitting(
                targetSize,
                withHorizontalFittingPriority: .fittingSizeLevel,
                verticalFittingPriority: .almostRequired
            )

            let width = containerWidth.map { containerWidth in
                min(intrinsicSize.width, containerWidth)
            } ?? intrinsicSize.width

            return CGSize(
                width: width,
                height: containerHeight
            )
        }

        return intrinsicSize
    }

    private func sizeWithHuggingWidthAndFixedHeight(containerWidth: CGFloat?, fixedHeight: CGFloat) -> CGSize {
        let targetSize = CGSize(
            width: UIView.layoutFittingCompressedSize.width,
            height: fixedHeight
        )

        let intrinsicSize = contentView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .fittingSizeLevel,
            verticalFittingPriority: .almostRequired
        )

        let width = containerWidth.map { containerWidth in
            min(intrinsicSize.width, containerWidth)
        } ?? intrinsicSize.width

        return CGSize(
            width: width,
            height: fixedHeight
        )
    }

    private func sizeWithHuggingWidthAndFillingHeight(containerWidth: CGFloat?, containerHeight: CGFloat) -> CGSize {
        let targetSize = CGSize(
            width: UIView.layoutFittingCompressedSize.width,
            height: containerHeight
        )

        let intrinsicSize = contentView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .fittingSizeLevel,
            verticalFittingPriority: .almostRequired
        )

        let width = containerWidth.map { containerWidth in
            min(intrinsicSize.width, containerWidth)
        } ?? intrinsicSize.width

        return CGSize(
            width: width,
            height: containerHeight
        )
    }

    private func sizeWithFillingWidthAndFillingHeight(containerWidth: CGFloat, containerHeight: CGFloat) -> CGSize {
        CGSize(
            width: containerWidth,
            height: containerHeight
        )
    }

    private func sizeWithFillingWidthAndFixedHeight(containerWidth: CGFloat, fixedHeight: CGFloat) -> CGSize {
        CGSize(
            width: containerWidth,
            height: fixedHeight
        )
    }

    private func sizeWithFillingWidthAndHuggingHeight(containerWidth: CGFloat, containerHeight: CGFloat?) -> CGSize {
        let targetSize = CGSize(
            width: containerWidth,
            height: UIView.layoutFittingCompressedSize.height
        )

        let intrinsicSize = contentView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .almostRequired,
            verticalFittingPriority: .fittingSizeLevel
        )

        let height = containerHeight.map { containerHeight in
            min(intrinsicSize.height, containerHeight)
        } ?? intrinsicSize.height

        return CGSize(
            width: containerWidth,
            height: height
        )
    }
}
#endif
