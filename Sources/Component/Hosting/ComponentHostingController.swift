import SwiftUI
import UIKit

internal final class ComponentHostingController<Content: View>: UIHostingController<Content> {

    @MainActor
    internal override init(rootView: Content) {
        super.init(rootView: rootView)

        if #available(iOS 16.4, tvOS 16.4, *) {
            safeAreaRegions = []
        } else {
            _disableSafeArea = true
        }
    }

    @MainActor
    @available(*, unavailable)
    internal required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    internal override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear
        view.clipsToBounds = false
    }
}
