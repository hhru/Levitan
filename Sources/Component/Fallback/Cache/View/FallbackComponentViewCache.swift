#if canImport(UIKit)
import UIKit

internal final class FallbackComponentViewCache {

    private var views: [ObjectIdentifier: Set<UIView>] = [:]

    internal func storeView<Content: FallbackComponent>(_ view: FallbackComponentBodyView<Content>) {
        let key = ObjectIdentifier(Content.self)
        var views = views[key] ?? []

        views.insert(view)

        self.views[key] = views
    }

    internal func restoreView<Content: FallbackComponent>(
        for type: Content.Type
    ) -> FallbackComponentBodyView<Content>? {
        let key = ObjectIdentifier(Content.self)

        guard var views = views[key], !views.isEmpty else {
            return nil
        }

        let view = views.removeFirst()

        self.views[key] = views

        return view as? FallbackComponentBodyView<Content>
    }
}
#endif
