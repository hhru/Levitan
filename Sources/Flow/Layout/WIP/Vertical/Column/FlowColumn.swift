#if canImport(UIKit)
import CoreGraphics
import Foundation

public struct FlowColumn: Equatable, Sendable {

    public let size: FlowColumnSize
    public let spacing: CGFloat
    public let alignment: FlowHorizontalAlignment

    public init(
        size: FlowColumnSize,
        spacing: CGFloat = .zero,
        alignment: FlowHorizontalAlignment = .center
    ) {
        self.size = size
        self.spacing = spacing
        self.alignment = alignment
    }
}
#endif
