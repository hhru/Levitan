#if canImport(UIKit)
import UIKit

public struct FlowScrollAnchor: Sendable {

    internal let position: UICollectionView.ScrollPosition
}

extension FlowScrollAnchor {

    public static let topLeading = Self(position: [.top, .left])
    public static let top = Self(position: [.top, .centeredHorizontally])
    public static let topTrailing = Self(position: [.top, .right])

    public static let leading = Self(position: [.centeredVertically, .left])
    public static let center = Self(position: [.centeredVertically, .centeredHorizontally])
    public static let trailing = Self(position: [.centeredVertically, .right])

    public static let bottomLeading = Self(position: [.bottom, .left])
    public static let bottom = Self(position: [.bottom, .centeredHorizontally])
    public static let bottomTrailing = Self(position: [.bottom, .right])
}
#endif
