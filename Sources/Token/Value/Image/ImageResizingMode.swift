import UIKit
import SwiftUI

public enum ImageResizingMode: TokenTraitProvider, Sendable {

    case tile
    case stretch

    public var uiResizingMode: UIImage.ResizingMode {
        switch self {
        case .tile:
            return .tile

        case .stretch:
            return .stretch
        }
    }

    public var resizingMode: Image.ResizingMode {
        switch self {
        case .stretch:
            return .stretch

        case .tile:
            return .tile
        }
    }
}
