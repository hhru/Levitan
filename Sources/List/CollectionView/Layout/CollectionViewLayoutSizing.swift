import CoreGraphics

internal struct CollectionViewLayoutSizing: Equatable {

    internal let width: ComponentSizingStrategy
    internal let height: ComponentSizingStrategy
    internal let proposedSize: CGSize
}
