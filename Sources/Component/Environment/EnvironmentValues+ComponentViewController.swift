#if canImport(UIKit1)
import SwiftUI
import UIKit

internal struct ComponentViewControllerEnvironmentValue {

    internal private(set) weak var viewController: UIViewController?
}

internal struct ComponentViewControllerEnvironmentKey: EnvironmentKey {

    internal static let defaultValue = ComponentViewControllerEnvironmentValue()
}

extension EnvironmentValues {

    /// Ближайший экземпляр `UIViewController` в окружении.
    ///
    /// Используется для встраивания SwiftUI-компонентов в UIKit-представление через `UIHostingController`.
    /// Поэтому рекомендуется переопределять этот параметр в каждом экземпляре `UIViewController`,
    /// иначе встраивание SwiftUI-представлений в UIKit может сработать некорректно.
    ///
    /// Если ближайший экземпляр `UIViewController` не определен,
    /// то система попытается самостоятельно найти его по цепочке `UIResponder`.
    public var componentViewController: UIViewController? {
        get { self[ComponentViewControllerEnvironmentKey.self].viewController }

        set {
            self[ComponentViewControllerEnvironmentKey.self] = ComponentViewControllerEnvironmentValue(
                viewController: newValue
            )
        }
    }
}
#endif
