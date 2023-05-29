import UIKit
import SwiftUI

public enum ImageSource: TokenTraitProvider, Sendable {

    case uiImage(UIImage)
    case resource(name: String, bundle: Bundle)

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

    public var image: Image {
        switch self {
        case let .uiImage(uiImage):
            return Image(uiImage: uiImage)

        case let .resource(name, bundle):
            return Image(name, bundle: bundle)
        }
    }
}

extension ImageSource: Equatable {

    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case let (.uiImage(lhs), .uiImage(rhs)):
            return lhs.isEqual(rhs)

        case let (.resource(lhsName, lhsBundle), .resource(rhsName, rhsBundle)):
            return (lhsName == rhsName) && (lhsBundle == rhsBundle)

        default:
            return false
        }
    }
}

extension ImageSource: Hashable {

    public func hash(into hasher: inout Hasher) {
        switch self {
        case let .uiImage(uiImage):
            hasher.combine(uiImage)

        case let .resource(name, bundle):
            hasher.combine(name)
            hasher.combine(bundle)
        }
    }
}
