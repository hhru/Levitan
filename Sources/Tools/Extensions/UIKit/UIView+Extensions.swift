#if canImport(UIKit)
import UIKit

extension UIView {

    internal func sizeWithFixedWidthAndFixedHeight(
        fixedWidth: CGFloat,
        fixedHeight: CGFloat
    ) -> CGSize {
        CGSize(width: fixedWidth, height: fixedHeight)
    }

    internal func sizeWithFixedWidthAndHuggingHeight(
        fixedWidth: CGFloat,
        containerHeight: CGFloat?
    ) -> CGSize {
        let targetSize = CGSize(
            width: fixedWidth,
            height: UIView.layoutFittingCompressedSize.height
        )

        let size = systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .almostRequired,
            verticalFittingPriority: .fittingSizeLevel
        )

        let height = containerHeight?.nonZero.map { containerHeight in
            min(size.height, containerHeight)
        } ?? size.height

        return CGSize(width: fixedWidth, height: height)
    }

    internal func sizeWithFixedWidthAndFillingHeight(
        fixedWidth: CGFloat,
        containerHeight: CGFloat?
    ) -> CGSize {
        if let height = containerHeight?.nonZero {
            return CGSize(width: fixedWidth, height: height)
        }

        let targetSize = CGSize(
            width: fixedWidth,
            height: UIView.layoutFittingCompressedSize.height
        )

        let size = systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .almostRequired,
            verticalFittingPriority: .fittingSizeLevel
        )

        return CGSize(width: fixedWidth, height: size.height)
    }

    internal func sizeWithHuggingWidthAndFixedHeight(
        containerWidth: CGFloat?,
        fixedHeight: CGFloat
    ) -> CGSize {
        let targetSize = CGSize(
            width: UIView.layoutFittingCompressedSize.width,
            height: fixedHeight
        )

        let size = systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .fittingSizeLevel,
            verticalFittingPriority: .almostRequired
        )

        let width = containerWidth?.nonZero.map { containerWidth in
            min(size.width, containerWidth)
        } ?? size.width

        return CGSize(width: width, height: fixedHeight)
    }

    internal func sizeWithHuggingWidthAndHuggingHeight(
        containerWidth: CGFloat?,
        containerHeight: CGFloat?
    ) -> CGSize {
        let size = systemLayoutSizeFitting(
            UIView.layoutFittingCompressedSize,
            withHorizontalFittingPriority: .fittingSizeLevel,
            verticalFittingPriority: .fittingSizeLevel
        )

        let containerWidth = containerWidth?.nonZero

        if let containerWidth, containerWidth < size.width {
            return sizeWithFixedWidthAndHuggingHeight(
                fixedWidth: containerWidth,
                containerHeight: containerHeight
            )
        }

        let containerHeight = containerHeight?.nonZero

        if let containerHeight = containerHeight?.nonZero, containerHeight < size.height {
            return sizeWithHuggingWidthAndFixedHeight(
                containerWidth: containerWidth,
                fixedHeight: containerHeight
            )
        }

        return size
    }

    internal func sizeWithHuggingWidthAndFillingHeight(
        containerWidth: CGFloat?,
        containerHeight: CGFloat?
    ) -> CGSize {
        let targetHeight = containerHeight?.nonZero.map { containerHeight in
            containerHeight.isInfinite
                ? UIView.layoutFittingExpandedSize.height
                : containerHeight
        } ?? UIView.layoutFittingCompressedSize.height

        let targetSize = CGSize(
            width: UIView.layoutFittingCompressedSize.width,
            height: targetHeight
        )

        let size = systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .fittingSizeLevel,
            verticalFittingPriority: containerHeight?.isNormal == true
                ? .almostRequired
                : .fittingSizeLevel
        )

        let containerWidth = containerWidth?.nonZero

        if let containerWidth, containerWidth < size.width {
            return sizeWithFixedWidthAndFillingHeight(
                fixedWidth: containerWidth,
                containerHeight: containerHeight
            )
        }

        let height = containerHeight?.nonZero ?? size.height

        return CGSize(width: size.width, height: height)
    }

    internal func sizeWithFillingWidthAndFixedHeight(
        containerWidth: CGFloat?,
        fixedHeight: CGFloat
    ) -> CGSize {
        if let width = containerWidth?.nonZero {
            return CGSize(width: width, height: fixedHeight)
        }

        let targetSize = CGSize(
            width: UIView.layoutFittingCompressedSize.width,
            height: fixedHeight
        )

        let size = systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .fittingSizeLevel,
            verticalFittingPriority: .almostRequired
        )

        return CGSize(width: size.width, height: fixedHeight)
    }

    internal func sizeWithFillingWidthAndHuggingHeight(
        containerWidth: CGFloat?,
        containerHeight: CGFloat?
    ) -> CGSize {
        let targetWidth = containerWidth?.nonZero.map { containerWidth in
            containerWidth.isInfinite
                ? UIView.layoutFittingExpandedSize.width
                : containerWidth
        } ?? UIView.layoutFittingCompressedSize.width

        let targetSize = CGSize(
            width: targetWidth,
            height: UIView.layoutFittingCompressedSize.height
        )

        let size = systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: containerWidth?.isNormal == true
                ? .almostRequired
                : .fittingSizeLevel,
            verticalFittingPriority: .fittingSizeLevel
        )

        let containerHeight = containerHeight?.nonZero

        if let containerHeight, containerHeight < size.height {
            return sizeWithFillingWidthAndFixedHeight(
                containerWidth: containerWidth,
                fixedHeight: containerHeight
            )
        }

        let width = containerWidth?.nonZero ?? size.width

        return CGSize(width: width, height: size.height)
    }

    internal func sizeWithFillingWidthAndFillingHeight(
        containerWidth: CGFloat?,
        containerHeight: CGFloat?
    ) -> CGSize {
        if let containerWidth = containerWidth?.nonZero {
            return sizeWithFixedWidthAndFillingHeight(
                fixedWidth: containerWidth,
                containerHeight: containerHeight
            )
        }

        if let containerHeight = containerHeight?.nonZero {
            return sizeWithFillingWidthAndFixedHeight(
                containerWidth: containerWidth,
                fixedHeight: containerHeight
            )
        }

        return systemLayoutSizeFitting(
            UIView.layoutFittingCompressedSize,
            withHorizontalFittingPriority: .fittingSizeLevel,
            verticalFittingPriority: .fittingSizeLevel
        )
    }
}
#endif
