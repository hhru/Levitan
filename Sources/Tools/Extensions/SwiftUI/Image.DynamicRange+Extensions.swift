#if canImport(UIKit)
import UIKit
import SwiftUI

@available(iOS 17.0, tvOS 17.0, *)
extension Image.DynamicRange {

    internal init?(_ dynamicRange: UIImage.DynamicRange) {
        switch dynamicRange {
        case .standard:
            self = .standard

        case .high:
            self = .high

        case .constrainedHigh:
            self = .constrainedHigh

        case .unspecified:
            return nil

        @unknown default:
            return nil
        }
    }
}
#endif
