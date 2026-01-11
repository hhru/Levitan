#if canImport(UIKit)
import SwiftUI
import UIKit

internal struct ComponentViewControllerStorage: Sendable {

    internal let viewController: @MainActor () -> UIViewController?
}

internal struct ComponentViewControllerEnvironmentKey: EnvironmentKey {

    internal static let defaultValue: ComponentViewControllerStorage? = nil
}

extension EnvironmentValues {

    internal var componentViewControllerStorage: ComponentViewControllerStorage? {
        get { self[ComponentViewControllerEnvironmentKey.self] }
        set { self[ComponentViewControllerEnvironmentKey.self] = newValue }
    }
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
    @MainActor
    public var componentViewController: UIViewController? {
        componentViewControllerStorage?.viewController()
    }
}

extension ComponentContext {

    /// Ближайший экземпляр `UIViewController` в окружении.
    ///
    /// Используется для встраивания SwiftUI-компонентов в UIKit-представление через `UIHostingController`.
    /// Поэтому рекомендуется переопределять этот параметр в каждом экземпляре `UIViewController`,
    /// иначе встраивание SwiftUI-представлений в UIKit может сработать некорректно.
    ///
    /// Если ближайший экземпляр `UIViewController` не определен,
    /// то система попытается самостоятельно найти его по цепочке `UIResponder`.
    @MainActor
    public var componentViewController: UIViewController? {
        self.componentViewControllerStorage?.viewController()
    }

    /// Устанавливает ближайший экземпляр `UIViewController` в окружении.
    ///
    /// Используется для встраивания SwiftUI-компонентов в UIKit-представление через `UIHostingController`.
    /// Поэтому рекомендуется переопределять этот параметр в каждом экземпляре `UIViewController`,
    /// иначе встраивание SwiftUI-представлений в UIKit может сработать некорректно.
    ///
    /// Если ближайший экземпляр `UIViewController` не определен,
    /// то система попытается самостоятельно найти его по цепочке `UIResponder`.
    public func componentViewController(_ viewController: UIViewController?) -> Self {
        self.componentViewControllerStorage(
            ComponentViewControllerStorage { [weak viewController] in
                viewController
            }
        )
    }

    /// Устанавливает замыкание, предоставляющее ближайший экземпляр `UIViewController` в окружении.
    ///
    /// Используется для встраивания SwiftUI-компонентов в UIKit-представление через `UIHostingController`.
    /// Поэтому рекомендуется переопределять этот параметр в каждом экземпляре `UIViewController`,
    /// иначе встраивание SwiftUI-представлений в UIKit может сработать некорректно.
    ///
    /// Если ближайший экземпляр `UIViewController` не определен,
    /// то система попытается самостоятельно найти его по цепочке `UIResponder`.
    public func componentViewControllerProvider(
        _ viewController: @escaping @MainActor () -> UIViewController?
    ) -> Self {
        self.componentViewControllerStorage(
            ComponentViewControllerStorage(viewController: viewController)
        )
    }
}
#endif
