#if canImport(UIKit)
import Foundation

/// Обертка для замыканий в UI-компонентах.
///
/// Позволяет игнорировать сравнение для замыканий, делая их всегда равными.
/// Исключением являются опциональные замыкания, они буду равны,
/// если только оба экземпляра либо  равны `nil`, либо имеют значение.
///
/// Так как в подавляющем большинстве случаев замыкания в свойствах UI-компонентов
/// вызывают один и тот же код, то сравнивать их вручную не имеет смысла.
/// Это допущение позволяет реализовывать требования протокола `Equatable`
/// без ручного сравнения остальных свойств, например:
///
/// ``` swift
/// struct FooBar: Component {
///
///     let title: String
///
///     @ViewAction
///     private var tapAction: () -> Void
///
///     var body: some View {
///         Button(title, action: tapAction)
///             .frame(width: .fill, height: .hug)
///             .padding()
///     }
///
///     func sizing(
///         fitting size: CGSize,
///         context: ComponentContext
///     ) -> ComponentSizing {
///         ComponentSizing(
///             width: .fill,
///             height: .hug
///         )
///     }
/// }
/// ```
@propertyWrapper
public struct ViewAction<Value> {

    public var wrappedValue: Value

    /// Создает Equatable-обертку для заданного замыкания.
    ///
    /// - Parameter wrappedValue: Замыкание.
    public init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }
}

extension ViewAction: Equatable {

    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs.wrappedValue as? Nullable, rhs.wrappedValue as? Nullable) {
        case let (lhs?, rhs?):
            return lhs.isNil == rhs.isNil

        case (nil, nil), (nil, _?), (_?, nil):
            return true
        }
    }
}

extension ViewAction: Hashable {

    public func hash(into hasher: inout Hasher) {
        if let value = wrappedValue as? Nullable, value.isNil {
            hasher.combine(false)
        } else {
            hasher.combine(true)
        }
    }
}
#endif
