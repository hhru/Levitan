#if canImport(UIKit)
import UIKit

extension UIScreen: TraitsObservable {

    internal static var swizzleTraitCollectionDidChangeMethod: () -> Void = {
        MethodSwizzler.swizzle(
            class: UIScreen.self,
            originalSelector: #selector(UIScreen.traitCollectionDidChange),
            swizzledSelector: #selector(UIScreen.tokensTraitCollectionDidChange)
        )

        return { }
    }()

    @objc
    private dynamic func tokensTraitCollectionDidChange(
        _ previousTraitCollection: UITraitCollection?
    ) {
        tokensTraitCollectionDidChange(previousTraitCollection)
        handleTraitCollectionDidChange(previousTraitCollection)
    }
}
#endif
