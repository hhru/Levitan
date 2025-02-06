#if canImport(UIKit1)
import UIKit
#endif

import SwiftUI

public enum ImageSource: TokenTraitProvider, Sendable {

    case resource(name: String, bundle: Bundle)

    #if canImport(UIKit1)
    case uiImage(UIImage)

    public var uiImage: UIImage {
        switch self {
        case let .uiImage(uiImage):
            return uiImage

        case let .resource(name, bundle):
            guard let uiImage = UIImage(named: name, in: bundle, compatibleWith: nil) else {
                fatalError("Unable to load image named \(name) in \(bundle).")
            }

            return uiImage
        }
    }
    #endif

    public var image: Image {
        switch self {
        case let .resource(name, bundle):
            return Image(name, bundle: bundle)

        #if canImport(UIKit1)

        case let .uiImage(uiImage):
            return Image(uiImage: uiImage)
        #endif
        }
    }
}

extension ImageSource: Equatable {

    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case let (.resource(lhsName, lhsBundle), .resource(rhsName, rhsBundle)):
            return (lhsName == rhsName) && (lhsBundle == rhsBundle)

        #if canImport(UIKit1)

        case let (.uiImage(lhs), .uiImage(rhs)):
            return lhs.isEqual(rhs)

        default:
            return false
        #endif
        }
    }
}

extension ImageSource: Hashable {

    public func hash(into hasher: inout Hasher) {
        switch self {
        case let .resource(name, bundle):
            hasher.combine(name)
            hasher.combine(bundle)

        #if canImport(UIKit1)

        case let .uiImage(uiImage):
            hasher.combine(uiImage)
        #endif
        }
    }
}
