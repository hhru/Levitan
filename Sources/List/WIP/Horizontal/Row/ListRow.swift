import Foundation

public struct ListRow: Equatable {

    public let size: ListRowSize
    public let spacing: CGFloat
    public let alignment: ListVerticalAlignment

    public init(
        size: ListRowSize,
        spacing: CGFloat = .zero,
        alignment: ListVerticalAlignment = .center
    ) {
        self.size = size
        self.spacing = spacing
        self.alignment = alignment
    }
}
