#if canImport(UIKit1)
import UIKit
#else
import Foundation
#endif

public struct CornersMask:
    OptionSet,
    Hashable,
    Sendable {

    public let rawValue: UInt

    #if canImport(UIKit1)
    #if os(iOS) || os(tvOS)
    public var caCornerMask: CACornerMask {
        let cornerMaskMap: KeyValuePairs<Self, CACornerMask> = [
            .topLeft: .layerMinXMinYCorner,
            .bottomLeft: .layerMinXMaxYCorner,
            .topRight: .layerMaxXMinYCorner,
            .bottomRight: .layerMaxXMaxYCorner
        ]

        return cornerMaskMap
            .lazy
            .filter { contains($0.key) }
            .reduce(into: CACornerMask()) { result, corner in
                result.insert(corner.value)
            }
    }
    #endif

    public var uiRectCorner: UIRectCorner {
        let cornerMaskMap: KeyValuePairs<Self, UIRectCorner> = [
            .topLeft: .topLeft,
            .bottomLeft: .bottomLeft,
            .topRight: .topRight,
            .bottomRight: .bottomRight
        ]

        return cornerMaskMap
            .lazy
            .filter { contains($0.key) }
            .reduce(into: UIRectCorner()) { result, corner in
                result.insert(corner.value)
            }
    }
    #endif

    public init(rawValue: UInt) {
        self.rawValue = rawValue
    }
}

extension CornersMask {

    public static let topLeft = Self(rawValue: 1 << 0)
    public static let topRight = Self(rawValue: 1 << 1)
    public static let bottomLeft = Self(rawValue: 1 << 2)
    public static let bottomRight = Self(rawValue: 1 << 3)

    public static let all: Self = [
        .topLeft,
        .topRight,
        .bottomLeft,
        .bottomRight
    ]
}
