#if canImport(UIKit)
import SwiftUI

internal struct ComponentMountingPolicyEnvironmentKey: EnvironmentKey {

    internal static let defaultValue: ComponentMountingPolicy = .deferred
}

extension EnvironmentValues {

    /// Политика монтирования SwiftUI-компонентов в UIKit-представление.
    ///
    /// Определяет момент, в который ``ComponentHostingView`` встраивает `UIHostingController`.
    /// По умолчанию монтирование откладывается до попадания представления в иерархию окна.
    ///
    /// - SeeAlso: ``ComponentMountingPolicy``
    public var componentMountingPolicy: ComponentMountingPolicy {
        get { self[ComponentMountingPolicyEnvironmentKey.self] }
        set { self[ComponentMountingPolicyEnvironmentKey.self] = newValue }
    }
}
#endif
