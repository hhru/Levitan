#if canImport(UIKit)
import UIKit
#endif

import SwiftUI

@frozen
public enum ImageResizingMode: TokenTraitProvider, Sendable {

    case tile
    case stretch

    #if canImport(UIKit)
    public var uiResizingMode: UIImage.ResizingMode {
        switch self {
        case .tile:
            return .tile

        case .stretch:
            return .stretch
        }
    }
    #endif

    public var resizingMode: Image.ResizingMode {
        switch self {
        case .stretch:
            return .stretch

        case .tile:
            return .tile
        }
    }
}
