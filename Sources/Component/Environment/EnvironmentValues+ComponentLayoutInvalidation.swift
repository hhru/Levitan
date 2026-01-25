#if canImport(UIKit)
import SwiftUI

internal struct ComponentLayoutInvalidationEnvironmentKey: EnvironmentKey {

    internal static let defaultValue = ComponentLayoutInvalidation(action: { })
}

extension EnvironmentValues {

    /// Действие для инвалидации лэйаута.
    ///
    /// Выполняется компонентом при изменении его внутренних размеров
    /// исключительно после изменения внутреннего состояния.
    ///
    /// - Warning: Не рекомендуется выполнять инвалидацию при изменении внешнего состояния,
    ///            переданного через байндинги или через ручное связывание замыканиями.
    ///            Компонент должен выполнять эти действия, только если изменилось его собственное состояние.
    public internal(set) var invalidateComponentLayout: ComponentLayoutInvalidation {
        get { self[ComponentLayoutInvalidationEnvironmentKey.self] }
        set { self[ComponentLayoutInvalidationEnvironmentKey.self] = newValue }
    }
}

extension ComponentContext {

    /// Добавляет дополнительное действие для инвалидации лэйаута.
    ///
    /// Некоторые UIKit-компоненты могут добавлять дополнительные действия
    /// для инвалидации своих размеров дочерними компонентами.
    /// Например, встроенная коллекция инвалидирует свой лэйаут
    /// и вызывает инвалидацию лэйаута родительской коллекции.
    ///
    /// В случае SwiftUI-компонентов добавлять дополнительные действия инвалидации не имеет смысла,
    /// SwiftUI обновляет лэйаут самостоятельно.
    ///
    /// - Note: Дополнительное действие инвалидации будет выполнено
    /// до выполнения уже имеющихся действий инвалидации.
    ///
    /// - Parameter invalidation: Дополнительное действие для инвалидации лэйаута.
    /// - Returns: Окружение с добавленным действием для инвалидации лэйаута.
    public func componentLayoutInvalidation(
        _ invalidation: @escaping @Sendable @MainActor () -> Void
    ) -> Self {
        let previousInvalidation = resolveValue(at: \.invalidateComponentLayout)

        let newInvalidation = ComponentLayoutInvalidation { [previousInvalidation] in
            invalidation()
            previousInvalidation()
        }

        let backdoor = ComponentContextOverride(
            keyPath: \.invalidateComponentLayout,
            value: newInvalidation
        )

        return Self(
            environment: environment,
            backdoors: backdoors.updatingValue(
                backdoor,
                forKey: \.invalidateComponentLayout
            ),
            overrides: overrides
        )
    }
}
#endif
