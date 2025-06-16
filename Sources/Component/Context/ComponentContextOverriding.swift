#if canImport(UIKit)
import SwiftUI

/// Вспомогательная структура-функция для переопределения переменных контекста компонентов.
///
/// Реализует метод `callAsFunction` и является универсальной функцией переопределения переменной окружения.
/// Поэтому нет необходимости реализовывать для каждой переменной окружения свой метод переопределения.
///
/// Создается в контексте компонента при обращении к переменной окружения через Dynamic Member Lookup.
///
/// - SeeAlso: ``ComponentContext``
public struct ComponentContextOverriding<Value> {

    /// Изначальный контекст.
    public let context: ComponentContext

    /// Ключ переменной окружения для переопределения ее значения.
    public let keyPath: WritableKeyPath<EnvironmentValues, Value>

    /// Изначальное значение переопределяемой переменной.
    @MainActor
    public var value: Value {
        context.resolveValue(at: keyPath)
    }

    public func callAsFunction(_ newValue: Value) -> ComponentContext {
        context.overrideValue(at: keyPath, with: newValue)
    }
}
#endif
