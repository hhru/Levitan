#if canImport(UIKit)
import SwiftUI

internal struct TextAnimationKey: EnvironmentKey {

    internal static let defaultValue = TextAnimation.default
}

extension EnvironmentValues {

    public var textAnimation: TextAnimation {
        get { self[TextAnimationKey.self] }
        set { self[TextAnimationKey.self] = newValue }
    }
}
#endif
