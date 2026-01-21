#if canImport(UIKit)
import Foundation

@MainActor
internal final class ComponentSubviewAppearanceStorage {

    internal private(set) weak var appearance: ComponentSubviewAppearance?

    internal init(appearance: ComponentSubviewAppearance) {
        self.appearance = appearance
    }
}
#endif
