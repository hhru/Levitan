#if canImport(UIKit)
import SwiftUI

/// Контекст компонента.
///
/// Является универсальным окружением для UIKit и SwiftUI компонентов
/// и предоставляет механизм переопределения его переменных.
///
/// Содержит изначальное окружение и отдельно переопределения его значений.
/// Такая структура позволяет наследовать полноценное окружение из SwiftUI,
/// заменяя в нем только переопределенные значения.
///
///
/// Начальный контекст
/// ===============
///
/// Если в прокте корневым является SwiftUI-компонент,
/// то нет необходимости создавать начальный контекст самостоятельно.
///
/// В случае корневого UIKit-компонента контекст создается в нем через static-свойство `default`.
/// В этом случае некоторые переменные получают значения из UIKit-характеристик `UITraitCollection`.
///
///
/// Использование в SwiftUI
/// ===================
///
/// Для SwiftUI контекст компонента трансформируется в обычное окружение,
/// и его использование ничем не отличается от использования в обычных UI-представлениях, например:
///
/// ``` swift
/// struct Foo: View {
///
///     @Environment(\.isEnabled)
///     private var isEnabled
///
///     var body: some View {
///         Text(isEnabled ? "Enabled" : "Disabled")
///             .dynamicTypeSize(.small) // переопределение переменной окружения
///     }
/// }
/// ```
///
/// Как видно из примера, переопределение происходит точно так же, как и с обычным UI-представлением.
/// Добавление новых переменных также аналогично стандартному механизму в SwiftUI.
///
///
/// Использование в UIKit
/// =================
///
/// В случае UIKit-компонентов контекст используется напрямую,
/// UI-представление компонента получает его в методе обновления `update(with:context:)`, например:
///
/// ``` swift
/// extension FooView: FallbackComponentView {
///
///     func update(with content: Foo, context: ComponentContext) {
///         label.text = context.isEnabled ? "Enabled" : "Disabled"
///     }
/// }
/// ```
///
/// Доступны все переменные окружения из SwiftUI, некоторые из них сами трансформируются в UIKit-характеристики,
/// например `dynamicTypeSize` в `UITraitCollection.preferredContentSizeCategory`.
///
/// Переопределение переменных в UIKit происходит через вызов соответствующих методов контекста, например:
///
/// ``` swift
/// extension FooView: ComponentView {
///
///     func update(with content: Foo, context: ComponentContext) {
///         barView.update(
///             with: Bar(),
///             // переопределение переменной окружения
///             context: context.dynamicTypeSize(.small)
///         )
///     }
/// }
/// ```
///
/// Добавление новых переменных также аналогично стандартному механизму в SwiftUI.
///
///
/// - SeeAlso: ``Component``
/// - SeeAlso: ``FallbackComponent``
/// - SeeAlso: ``ComponentContextOverriding``
/// - SeeAlso: ``ViewEnvironment``
@dynamicMemberLookup
public struct ComponentContext {

    internal let environment: EnvironmentValues?
    internal let overrides: [PartialKeyPath<EnvironmentValues>: ComponentContextOverride]

    internal func resolveValue<Value>(at keyPath: KeyPath<EnvironmentValues, Value>) -> Value {
        if let value = overrides[keyPath].flatMap({ $0.value as? Value }) {
            return value
        }

        let environment = environment ?? .default

        return environment[keyPath: keyPath]
    }

    internal func overrideValue<Value>(
        at keyPath: WritableKeyPath<EnvironmentValues, Value>,
        with newValue: Value
    ) -> Self {
        let override = ComponentContextOverride(
            keyPath: keyPath,
            value: newValue
        )

        let overrides = overrides.updatingValue(override, forKey: keyPath)

        return Self(
            environment: environment,
            overrides: overrides
        )
    }

    /// Переопределяет переменную с заданным ключом, используя замыкание для модификации его значения.
    ///
    /// - Parameters:
    ///   - keyPath: Ключ переменной окружения.
    ///   - transform: Замыкание, трасформирующее текущее значение переменной окружения.
    /// - Returns: Окружение с переопределенной переменной.
    public func transformEnvironment<Value>(
        _ keyPath: WritableKeyPath<EnvironmentValues, Value>,
        transform: @escaping (inout Value) -> Void
    ) -> Self {
        var value = resolveValue(at: keyPath)

        transform(&value)

        return overrideValue(at: keyPath, with: value)
    }

    /// Переопределяет переменную с заданным ключом новым значением.
    ///
    /// - Parameters:
    ///   - keyPath: Ключ переменной окружения.
    ///   - value: Новое значение переменной.
    /// - Returns: Окружение с переопределенной переменной.
    public func environment<Value>(
        _ keyPath: WritableKeyPath<EnvironmentValues, Value>,
        _ value: Value
    ) -> Self {
        overrideValue(at: keyPath, with: value)
    }

    /// Переопределяет переменную `isEnabled` аналогично переопределению в SwiftUI.
    ///
    /// Как и в SwiftUI, переопределенное значение будет игонироваться,
    /// если переменная `isEnabled` уже имеет значение `false`.
    ///
    /// - Parameter isDisabled: новое значение.
    /// - Returns: Окружение с переопределенной переменной.
    public func disabled(_ isDisabled: Bool = true) -> Self {
        self.isEnabled(!isDisabled && self.isEnabled)
    }

    /// Извлекает значение для заданного ключа переменной окружения.
    ///
    /// - Parameter keyPath: Ключ переменной окружения.
    /// - Returns: Значение переменной окружения.
    public subscript<Value>(dynamicMember keyPath: KeyPath<EnvironmentValues, Value>) -> Value {
        resolveValue(at: keyPath)
    }

    /// Создает вспомогательную структуру-функцию для переопределения переменной окружения.
    ///
    /// - Parameter keyPath: Ключ переменной окружения.
    /// - Returns: Структура-функция для переопределения переменной окружения.
    public subscript<Value>(
        dynamicMember keyPath: WritableKeyPath<EnvironmentValues, Value>
    ) -> ComponentContextOverriding<Value> {
        ComponentContextOverriding(
            context: self,
            keyPath: keyPath
        )
    }
}

extension ComponentContext {

    /// Контекст по умолчанию.
    ///
    /// Рекомендуется использовать в корневом UIKit-компоненте.
    /// Но также допускается использование по месту для обнуления контекста или в целях миграции.
    public static let `default` = Self(
        environment: nil,
        overrides: [:]
    )
}
#endif
