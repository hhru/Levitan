#if canImport(UIKit)
import UIKit

extension UIView {

    internal func sizeWithFixedWidthAndFixedHeight(fixedWidth: CGFloat, fixedHeight: CGFloat) -> CGSize {
        CGSize(width: fixedWidth, height: fixedHeight)
    }

    internal func sizeWithFixedWidthAndHuggingHeight(fixedWidth: CGFloat, proposedHeight: CGFloat?) -> CGSize {
        let targetSize = CGSize(
            width: fixedWidth,
            height: UIView.layoutFittingCompressedSize.height
        )

        let size = systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .almostRequired,
            verticalFittingPriority: .fittingSizeLevel
        )

        let height = proposedHeight?.nonZero.map { proposedHeight in
            min(size.height, proposedHeight)
        } ?? size.height

        return CGSize(width: fixedWidth, height: height)
    }

    internal func sizeWithFixedWidthAndFillingHeight(fixedWidth: CGFloat, proposedHeight: CGFloat?) -> CGSize {
        switch proposedHeight?.nonZero {
        case nil:
            let targetSize = CGSize(
                width: fixedWidth,
                height: UIView.layoutFittingCompressedSize.height
            )

            return systemLayoutSizeFitting(
                targetSize,
                withHorizontalFittingPriority: .almostRequired,
                verticalFittingPriority: .fittingSizeLevel
            )

        case let height?:
            return CGSize(width: fixedWidth, height: height)
        }
    }

    internal func sizeWithHuggingWidthAndHuggingHeight(proposedWidth: CGFloat?, proposedHeight: CGFloat?) -> CGSize {
        let size = systemLayoutSizeFitting(
            UIView.layoutFittingCompressedSize,
            withHorizontalFittingPriority: .fittingSizeLevel,
            verticalFittingPriority: .fittingSizeLevel
        )

        if let proposedWidth = proposedWidth?.nonZero, proposedWidth < size.width {
            let targetSize = CGSize(
                width: proposedWidth,
                height: UIView.layoutFittingCompressedSize.height
            )

            let size = systemLayoutSizeFitting(
                targetSize,
                withHorizontalFittingPriority: .almostRequired,
                verticalFittingPriority: .fittingSizeLevel
            )

            let height = proposedHeight?.nonZero.map { proposedHeight in
                min(size.height, proposedHeight)
            } ?? size.height

            return CGSize(width: proposedWidth, height: height)
        }

        if let proposedHeight = proposedHeight?.nonZero, proposedHeight < size.height {
            let targetSize = CGSize(
                width: UIView.layoutFittingCompressedSize.width,
                height: proposedHeight
            )

            let size = systemLayoutSizeFitting(
                targetSize,
                withHorizontalFittingPriority: .fittingSizeLevel,
                verticalFittingPriority: .almostRequired
            )

            let width = proposedWidth?.nonZero.map { proposedWidth in
                min(size.width, proposedWidth)
            } ?? size.width

            return CGSize(width: width, height: proposedHeight)
        }

        return size
    }

    internal func sizeWithHuggingWidthAndFixedHeight(proposedWidth: CGFloat?, fixedHeight: CGFloat) -> CGSize {
        let targetSize = CGSize(
            width: UIView.layoutFittingCompressedSize.width,
            height: fixedHeight
        )

        let size = systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .fittingSizeLevel,
            verticalFittingPriority: .almostRequired
        )

        let width = proposedWidth?.nonZero.map { proposedWidth in
            min(size.width, proposedWidth)
        } ?? size.width

        return CGSize(width: width, height: fixedHeight)
    }

    internal func sizeWithHuggingWidthAndFillingHeight(proposedWidth: CGFloat?, proposedHeight: CGFloat?) -> CGSize {
        let targetHeight = proposedHeight?.nonZero.map { proposedHeight in
            proposedHeight.isInfinite
                ? UIView.layoutFittingExpandedSize.height
                : proposedHeight
        } ?? UIView.layoutFittingCompressedSize.height

        let targetSize = CGSize(
            width: UIView.layoutFittingCompressedSize.width,
            height: targetHeight
        )

        let size = systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .fittingSizeLevel,
            verticalFittingPriority: proposedHeight?.isNormal == true
                ? .almostRequired
                : .fittingSizeLevel
        )

        if let proposedWidth = proposedWidth?.nonZero, proposedWidth < size.width {
            if let proposedHeight = proposedHeight?.nonZero {
                return CGSize(width: proposedWidth, height: proposedHeight)
            }

            let targetSize = CGSize(width: proposedWidth, height: targetHeight)

            let size = systemLayoutSizeFitting(
                targetSize,
                withHorizontalFittingPriority: .almostRequired,
                verticalFittingPriority: .fittingSizeLevel
            )

            return CGSize(width: proposedWidth, height: size.height)
        }

        let height = proposedHeight?.nonZero ?? size.height

        return CGSize(width: size.width, height: height)
    }

    internal func sizeWithFillingWidthAndFillingHeight(proposedWidth: CGFloat?, proposedHeight: CGFloat?) -> CGSize {
        switch (proposedWidth?.nonZero, proposedHeight?.nonZero) {
        case (nil, nil):
            return systemLayoutSizeFitting(
                UIView.layoutFittingCompressedSize,
                withHorizontalFittingPriority: .fittingSizeLevel,
                verticalFittingPriority: .fittingSizeLevel
            )

        case let (width?, nil):
            let targetSize = CGSize(
                width: width,
                height: UIView.layoutFittingCompressedSize.height
            )

            let size = systemLayoutSizeFitting(
                targetSize,
                withHorizontalFittingPriority: .almostRequired,
                verticalFittingPriority: .fittingSizeLevel
            )

            return CGSize(width: width, height: size.height)

        case let (nil, height?):
            let targetSize = CGSize(
                width: UIView.layoutFittingCompressedSize.width,
                height: height
            )

            let size = systemLayoutSizeFitting(
                targetSize,
                withHorizontalFittingPriority: .fittingSizeLevel,
                verticalFittingPriority: .almostRequired
            )

            return CGSize(width: size.width, height: height)

        case let (width?, height?):
            return CGSize(width: width, height: height)
        }
    }

    internal func sizeWithFillingWidthAndFixedHeight(proposedWidth: CGFloat?, fixedHeight: CGFloat) -> CGSize {
        switch proposedWidth?.nonZero {
        case nil:
            let targetSize = CGSize(
                width: UIView.layoutFittingCompressedSize.width,
                height: fixedHeight
            )

            return systemLayoutSizeFitting(
                targetSize,
                withHorizontalFittingPriority: .fittingSizeLevel,
                verticalFittingPriority: .almostRequired
            )

        case let width?:
            return CGSize(width: width, height: fixedHeight)
        }
    }

    internal func sizeWithFillingWidthAndHuggingHeight(proposedWidth: CGFloat?, proposedHeight: CGFloat?) -> CGSize {
        let targetWidth = proposedWidth?.nonZero.map { proposedWidth in
            proposedWidth.isInfinite
                ? UIView.layoutFittingExpandedSize.width
                : proposedWidth
        } ?? UIView.layoutFittingCompressedSize.width

        let targetSize = CGSize(
            width: targetWidth,
            height: UIView.layoutFittingCompressedSize.height
        )

        let size = systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: proposedWidth?.isNormal == true
                ? .almostRequired
                : .fittingSizeLevel,
            verticalFittingPriority: .fittingSizeLevel
        )

        if let proposedHeight = proposedHeight?.nonZero, proposedHeight < size.height {
            if let proposedWidth = proposedWidth?.nonZero {
                return CGSize(width: proposedWidth, height: proposedHeight)
            }

            let targetSize = CGSize(width: targetWidth, height: proposedHeight)

            let size = systemLayoutSizeFitting(
                targetSize,
                withHorizontalFittingPriority: .fittingSizeLevel,
                verticalFittingPriority: .almostRequired
            )

            return CGSize(width: size.width, height: proposedHeight)
        }

        let width = proposedWidth?.nonZero ?? size.width

        return CGSize(width: width, height: size.height)
    }
}
#endif
