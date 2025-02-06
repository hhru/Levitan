#if canImport(UIKit)
import UIKit

extension UIView: TraitsObservable {

    internal static var swizzleTraitCollectionDidChangeMethod: () -> Void = {
        MethodSwizzler.swizzle(
            class: UIView.self,
            originalSelector: #selector(UIView.traitCollectionDidChange),
            swizzledSelector: #selector(UIView.tokensTraitCollectionDidChange)
        )

        return { }
    }()

    @objc
    private dynamic func tokensTraitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        tokensTraitCollectionDidChange(previousTraitCollection)
        handleTraitCollectionDidChange(previousTraitCollection)
    }
}
#endif
