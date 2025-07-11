#if canImport(UIKit)
import SwiftUI
import UIKit

internal struct ComponentViewControllerEnvironmentKey: EnvironmentKey {

    internal static let defaultValue: @Sendable @MainActor () -> UIViewController? = { nil }
}

extension EnvironmentValues {

    /// Замыкание, который предоставляет ближайший экземпляр `UIViewController` в окружении.
    ///
    /// Используется для встраивания SwiftUI-компонентов в UIKit-представление через `UIHostingController`.
    /// Поэтому рекомендуется переопределять этот параметр в каждом экземпляре `UIViewController`,
    /// иначе встраивание SwiftUI-представлений в UIKit может сработать некорректно.
    ///
    /// Если ближайший экземпляр `UIViewController` не определен,
    /// то система попытается самостоятельно найти его по цепочке `UIResponder`.
    public var componentViewControllerProvider: @Sendable @MainActor () -> UIViewController? {
        get { self[ComponentViewControllerEnvironmentKey.self] }
        set { self[ComponentViewControllerEnvironmentKey.self] = newValue }
    }
}

extension ComponentContext {

    /// Возвращает ближайший экземпляр `UIViewController` в окружении
    /// для встраивания SwiftUI-компонентов в UIKit-представление через `UIHostingController`.
    @MainActor
    public var componentViewController: UIViewController? {
        self.componentViewControllerProvider()
    }

    /// Устанавливает ближайший экземпляр `UIViewController` в окружении
    /// для встраивания SwiftUI-компонентов в UIKit-представление через `UIHostingController`.
    ///
    /// - Parameter viewController: Экземпляр `UIViewController`.
    /// - Returns: Окружение с переопределенным экземпляром `UIViewController`.
    public func componentViewController(_ viewController: UIViewController?) -> Self {
        self.componentViewControllerProvider { [weak viewController] in
            viewController
        }
    }
}
#endif
