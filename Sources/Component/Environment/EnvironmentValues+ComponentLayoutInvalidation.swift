import SwiftUI

internal struct ComponentLayoutInvalidationEnvironmentKey: EnvironmentKey {

    internal static let defaultValue = { }
}

extension EnvironmentValues {

    /// Действие для инвалидации лэйаута.
    ///
    /// Выполняется компонентом при изменении его внутренних размеров
    /// исключительно после изменения внутреннего состояния.
    ///
    /// Каждый компонент может добавлять дополнительные действия
    /// для инвалидации своих размеров дочерними компонентами.
    /// Например, встроенная коллекция инвалидирует свой лэйаут
    /// и вызывает инвалидацию у родительской коллекции.
    ///
    /// - Warning: Не рекомендуется вызывать инвалидацию при изменении внешнего состояния,
    ///            переданного через байндинги или через ручное связывание замыканиями.
    ///            Компонент должен выполнять это действие только, если изменилось его собственное состояние.
    public internal(set) var invalidateComponentLayout: () -> Void {
        get { self[ComponentLayoutInvalidationEnvironmentKey.self] }
        set { self[ComponentLayoutInvalidationEnvironmentKey.self] = newValue }
    }
}

extension ComponentContext {

    /// Добавляет дополнительное действие для инвалидации лэйаута.
    ///
    /// Дополнительное действие будет выполнено до выполнения уже имеющихся действий инвалидации.
    ///
    /// - Parameter invalidation: Дополнительное действие для инвалидации лэйаута.
    /// - Returns: Окружение с добавленным действием для инвалидации лэйаута.
    public func componentLayoutInvalidation(_ invalidation: @escaping () -> Void) -> Self {
        transformEnvironment(\.invalidateComponentLayout) { currentInvalidation in
            currentInvalidation = { [currentInvalidation] in
                invalidation()
                currentInvalidation()
            }
        }
    }
}
