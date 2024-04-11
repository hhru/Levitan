import CoreGraphics

public struct ListColumn: Equatable {

    public let size: ListColumnSize
    public let spacing: CGFloat
    public let alignment: ListHorizontalAlignment

    public init(
        size: ListColumnSize,
        spacing: CGFloat = .zero,
        alignment: ListHorizontalAlignment = .center
    ) {
        self.size = size
        self.spacing = spacing
        self.alignment = alignment
    }
}
