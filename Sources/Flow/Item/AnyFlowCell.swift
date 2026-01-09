#if canImport(UIKit)
import UIKit

open class AnyFlowCell: UICollectionViewCell {

    public typealias Deselection = (_ animated: Bool) -> Void

    open class var reuseIdentifier: String {
        "\(ObjectIdentifier(Self.self))"
    }

    open func onSelect(deselection: Deselection) { }
    open func onDeselect() { }

    open func onAppear() { }
    open func onDisappear() { }

    open override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        guard let layoutAttributes = layoutAttributes as? CollectionViewLayoutAttributes else {
            return super.apply(layoutAttributes)
        }

        if let sizing = layoutAttributes.sizing {
            Logger.debug(
                ["\(Self.self).\(#function)"],
                ["estimatedSize:", layoutAttributes.frame.size],
                ["containerSize:", sizing.containerSize],
                ["width:", sizing.width],
                ["height:", sizing.height],
                subsystem: "Flow",
                category: "AnyFlowCell"
            )
        } else {
            Logger.debug(
                ["\(Self.self).\(#function)"],
                ["actualSize:", layoutAttributes.frame.size],
                subsystem: "Flow",
                category: "AnyFlowCell"
            )
        }

        super.apply(layoutAttributes)
    }

    open override func preferredLayoutAttributesFitting(
        _ layoutAttributes: UICollectionViewLayoutAttributes
    ) -> UICollectionViewLayoutAttributes {
        guard let layoutAttributes = layoutAttributes as? CollectionViewLayoutAttributes else {
            return super.preferredLayoutAttributesFitting(layoutAttributes)
        }

        if let sizing = layoutAttributes.sizing {
            Logger.debug(
                ["\(Self.self).\(#function)"],
                ["estimatedSize:", layoutAttributes.frame.size],
                ["containerSize:", sizing.containerSize],
                ["width:", sizing.width],
                ["height:", sizing.height],
                subsystem: "Flow",
                category: "AnyFlowCell"
            )
        } else {
            Logger.debug(
                ["\(Self.self).\(#function)"],
                ["actualSize:", layoutAttributes.frame.size],
                subsystem: "Flow",
                category: "AnyFlowCell"
            )
        }

        guard let sizing = layoutAttributes.sizing else {
            return layoutAttributes
        }

        layoutAttributes.size = size(for: sizing)

        Logger.debug(
            ["\(Self.self).\(#function) -- END"],
            ["newActualSize:", layoutAttributes.size],
            subsystem: "Flow",
            category: "AnyFlowCell"
        )

        return layoutAttributes
    }
}

extension AnyFlowCell {

    // swiftlint:disable:next function_body_length
    private func size(for sizing: CollectionViewLayoutSizing) -> CGSize {
        switch (sizing.width, sizing.height) {
        case let (.fixed(fixedWidth), .fixed(fixedHeight)):
            contentView.sizeWithFixedWidthAndFixedHeight(
                width: fixedWidth,
                height: fixedHeight
            )

        case let (.fixed(fixedWidth), .hug):
            contentView.sizeWithFixedWidthAndHuggingHeight(
                width: fixedWidth,
                containerHeight: sizing.containerSize.height,
                maxHeight: sizing.boundingSize.height
            )

        case let (.fixed(fixedWidth), .fill):
            contentView.sizeWithFixedWidthAndFillingHeight(
                width: fixedWidth,
                containerHeight: sizing.containerSize.height
            )

        case let (.hug, .fixed(fixedHeight)):
            contentView.sizeWithHuggingWidthAndFixedHeight(
                containerWidth: sizing.containerSize.width,
                maxWidth: sizing.boundingSize.width,
                height: fixedHeight
            )

        case (.hug, .hug):
            contentView.sizeWithHuggingWidthAndHuggingHeight(
                containerWidth: sizing.containerSize.width,
                maxWidth: sizing.boundingSize.width,
                containerHeight: sizing.containerSize.height,
                maxHeight: sizing.boundingSize.height
            )

        case (.hug, .fill):
            contentView.sizeWithHuggingWidthAndFillingHeight(
                containerWidth: sizing.containerSize.width,
                maxWidth: sizing.boundingSize.width,
                containerHeight: sizing.containerSize.height
            )

        case let (.fill, .fixed(fixedHeight)):
            contentView.sizeWithFillingWidthAndFixedHeight(
                containerWidth: sizing.containerSize.width,
                height: fixedHeight
            )

        case (.fill, .hug):
            contentView.sizeWithFillingWidthAndHuggingHeight(
                containerWidth: sizing.containerSize.width,
                containerHeight: sizing.containerSize.height,
                maxHeight: sizing.boundingSize.height
            )

        case (.fill, .fill):
            contentView.sizeWithFillingWidthAndFillingHeight(
                containerWidth: sizing.containerSize.width,
                containerHeight: sizing.containerSize.height
            )
        }
    }
}
#endif
