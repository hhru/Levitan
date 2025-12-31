#if canImport(UIKit)
import Foundation

public struct FlowRow: Equatable, Sendable {

    public let size: FlowRowSize
    public let spacing: CGFloat
    public let alignment: FlowVerticalAlignment

    public init(
        size: FlowRowSize,
        spacing: CGFloat = .zero,
        alignment: FlowVerticalAlignment = .center
    ) {
        self.size = size
        self.spacing = spacing
        self.alignment = alignment
    }
}
#endif
