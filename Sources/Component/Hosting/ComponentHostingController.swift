import SwiftUI
import UIKit

internal final class ComponentHostingController<Content: View>: UIHostingController<Content> {

    // До iOS 16 UIHostingController самовольно отображает скрытую панель навигации.
    // Чтобы это предотвратить, переопределяем для него navigationController
    // и возвращаем nil для iOS старше 16.
    internal override var navigationController: UINavigationController? {
        if #available(iOS 16.0, tvOS 16.0, *) {
            return super.navigationController
        }

        return nil
    }

    internal override init(rootView: Content) {
        super.init(rootView: rootView)

        if #available(iOS 16.4, tvOS 16.4, *) {
            safeAreaRegions = []
        } else {
            _disableSafeArea = true
        }
    }

    @available(*, unavailable)
    internal required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    internal override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear
    }
}
