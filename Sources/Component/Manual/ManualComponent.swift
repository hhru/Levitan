import Foundation

/// Частный случай протокола `Component`, Размеры UI-компонента фиксированы и задаются вручную, пример:
///
/// ``` swift
/// struct Foo: ManualComponent {
///
///     let text: String
///
///     var body: some View {
///         Text(text)
///     }
///
///     func size(fitting size: CGSize, context: ComponentContext) -> CGSize {
///         CGSize(width: 240.0, height: 20.0)
///     }
/// }
/// ```
///
/// Любой UI-компонент, соответствующий этому протоколу `ManualComponent`,
/// так же соответствует протоколу `Component`, поэтому так же может быть использован в SwiftUI.
///
/// - SeeAlso: ``Component``
/// - SeeAlso: ``ComponentSizingStrategy``
/// - SeeAlso: ``FallbackManualComponent``
/// - SeeAlso: ``AnyManualComponent``
public protocol ManualComponent: Component {

    func size(
        fitting size: CGSize,
        context: ComponentContext
    ) -> CGSize
}

extension ManualComponent where UIView == ComponentHostingView<Self> {

    public func sizing(
        fitting size: CGSize,
        context: ComponentContext
    ) -> ComponentSizing {
        let size = self.size(
            fitting: size,
            context: context
        )

        return ComponentSizing(
            width: .fixed(size.width),
            height: .fixed(size.height)
        )
    }
}
