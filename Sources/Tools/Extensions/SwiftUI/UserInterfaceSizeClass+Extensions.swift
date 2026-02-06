#if canImport(UIKit)
import UIKit
import SwiftUI

extension UserInterfaceSizeClass {

    internal init?(_ sizeClass: UIUserInterfaceSizeClass) {
        switch sizeClass {
        case .regular:
            self = .regular

        case .compact:
            self = .compact

        case .unspecified:
            return nil

        @unknown default:
            return nil
        }
    }
}
#endif
