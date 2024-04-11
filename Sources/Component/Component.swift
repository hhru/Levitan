import SwiftUI

/// Общий протокол для всех UI-компонентов.
///
/// Протокол `Component` максимально приспособлен для реализации SwiftUI-компонентов,
/// достаточно реализовать стандартное свойство `body` и метод `sizing(fitting:context:)`, например:
///
/// ``` swift
/// struct Foo: Component {
///
///     let text: String
///
///     var body: some View {
///         Text(text)
///     }
///
///     func sizing(fitting size: CGSize, context: ComponentContext) -> ComponentSizing {
///         ComponentSizing(width: .fill, height: .hug)
///     }
/// }
/// ```
///
/// Для удобства реализации UIKit-компонентов используется протокол `FallbackComponent`,
/// который так же соответствует протоколу `Component`,
/// но предоставляет другую реализацию по умолчанию для некоторых его полей.
///
/// Любой UI-компонент, соответствующий этому протоколу `Component`,
/// можно использовать и в SwiftUI, и UIKit.
///
///
/// Использование в SwiftUI
/// ===================
///
/// Использование компонента в SwiftUI ничем не отличается от использования обычного UI-представления, например:
///
/// ``` swift
/// struct Bar: View {
///
///     var body: some View {
///         Foo(text: "Hello world")
///     }
/// }
/// ```
///
///
/// Использование в UIKit
/// =================
///
/// В UIKit данные и UI-представление разделены, при этом сам компонент является данными.
/// UI-представление создается под ассоциированным типом `UIView` компонента,
/// а данные обновляются его методом `update(with:context:)`, например:
///
/// ``` swift
/// class BarView: UIView {
///
///     let fooView = Foo.UIView()
///
///     override init(frame: CGRect = .zero) {
///         super.init(frame: frame)
///
///         setupFooView()
///     }
///
///     func setupFooView() {
///         addSubview(fooView)
///
///         fooView.snp.makeConstraints { make in
///             make.edges.equalToSuperview()
///         }
///
///         // Обновление компонента
///         fooView.update(
///             with: Foo(text: "Hello world"),
///             context: .default
///         )
///     }
/// }
/// ```
///
/// В этом примере UI-представление компонента обновляется, используя контекст по умолчанию,
/// но в реальном приложении рекомендуется создавать его на уровне корневого компонента
/// и передавать по цепочке в иерархии компонентов.
///
///
/// - SeeAlso: ``FallbackComponent``
/// - SeeAlso: ``ComponentContext``
/// - SeeAlso: ``ComponentView``
public protocol Component: View, Equatable {

    /// UIKit-представление компонента для использования в UIKit-контейнере.
    ///
    /// По-умолчанию UIKit-представлением является `ComponentHostingView`,
    /// который позволяет использовать SwiftUI-компоненты в UIKit.
    ///
    /// - SeeAlso: ``ComponentView``
    /// - SeeAlso: ``ComponentHostingView``
    associatedtype UIView = ComponentHostingView<Self>
    where UIView: ComponentView, UIView.Content == Self

    /// Возвращает данные для определения размеров компонента.
    ///
    /// Используется при встраивании любого компонента в Lazy-контейнер (например, коллекцию)
    /// или при встраивании UIKit-компонента в SwiftUI-представление.
    ///
    /// - Note: Может быть вызван многократно в рамках прохода лэйаута.
    ///
    /// - Parameters:
    ///   - size: Предлагаемый размер компонента. Чаще всего является размером контейнера.
    ///   - context: Контекст компонента.
    /// - Returns: Данные для определения размеров компонента.
    ///
    /// - SeeAlso: ``ComponentSizing``
    /// - SeeAlso: ``ComponentContext``
    func sizing(
        fitting size: CGSize,
        context: ComponentContext
    ) -> ComponentSizing
}

extension Component {

    internal func isEqual(to other: any Component) -> Bool {
        guard let other = other as? Self else {
            return false
        }

        return self == other
    }
}
