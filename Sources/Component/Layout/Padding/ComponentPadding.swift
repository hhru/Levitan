#if canImport(UIKit)
import SwiftUI

/// Контейнер для добавления отступов к компонентам.
///
/// - SeeAlso: ``ComponentSizing``
/// - SeeAlso: ``Component``
public struct ComponentPadding<Content: View> {

    /// Компонент, который будет обернут в контейнер.
    public let content: Content

    /// Отступы, которые будут применены к компоненту.
    public var insets: EdgeInsets

    /// Создает контейнер c отступами.
    ///
    /// - Parameters:
    ///   - content: Компонент, который будет обернут в контейнер.
    ///   - insets: Отступы, которые будут применены к компоненту.
    public init(
        content: Content,
        insets: EdgeInsets
    ) {
        self.content = content
        self.insets = insets
    }
}

extension ComponentPadding: Equatable where Content: Equatable { }
extension ComponentPadding: Sendable where Content: Sendable { }

extension ComponentPadding: View {

    public var body: some View {
        content.padding(insets)
    }
}

extension ComponentPadding: Component where Content: Component {

    public typealias UIView = ComponentPaddingView<Content>

    public func sizing(fitting size: CGSize, context: ComponentContext) -> ComponentSizing {
        let sizing = content.sizing(
            fitting: size,
            context: context
        )

        switch (sizing.width, sizing.height) {
        case let (.fixed(width), .fixed(height)):
            return ComponentSizing(
                width: .fixed(width + insets.horizontal),
                height: .fixed(height + insets.vertical)
            )

        case let (.fixed(width), height):
            return ComponentSizing(
                width: .fixed(width + insets.horizontal),
                height: height
            )

        case let (width, .fixed(height)):
            return ComponentSizing(
                width: width,
                height: .fixed(height + insets.vertical)
            )

        default:
            return sizing
        }
    }
}

extension ComponentPadding: Changeable {

    /// Добавляет дополнительные отступы к текущим отступам контейнера.
    ///
    /// - Parameter insets: Отступы, которые будут применены к компоненту.
    /// - Returns: Контейнер для добавления отступов к компоненту.
    ///
    /// - SeeAlso: ``ComponentPadding``
    public nonisolated func padding(_ insets: EdgeInsets) -> Self {
        changing { padding in
            padding.insets = EdgeInsets(
                top: padding.insets.top + insets.top,
                leading: padding.insets.leading + insets.leading,
                bottom: padding.insets.bottom + insets.bottom,
                trailing: padding.insets.trailing + insets.trailing
            )
        }
    }

    /// Добавляет дополнительные отступы к текущим отступам контейнера.
    ///
    /// - Parameters:
    ///   - top: Верхний отступ. По умолчанию равен `0.0`.
    ///   - leading: Ведущий отступ. По умолчанию равен `0.0`.
    ///   - bottom: Нижний отступ. По умолчанию равен `0.0`.
    ///   - trailing: Замыкающий отступ. По умолчанию равен `0.0`.
    /// - Returns: Контейнер для добавления отступов к компоненту.
    ///
    /// - SeeAlso: ``ComponentPadding``
    public nonisolated func padding(
        top: CGFloat = .zero,
        leading: CGFloat = .zero,
        bottom: CGFloat = .zero,
        trailing: CGFloat = .zero
    ) -> Self {
        padding(
            EdgeInsets(
                top: top,
                leading: leading,
                bottom: bottom,
                trailing: trailing
            )
        )
    }

    /// Добавляет дополнительные отступы к текущим отступам контейнера.
    ///
    /// - Parameters:
    ///   - edge: Набор краев, к которым будет применен отступ.
    ///   - length: Значение отступа.
    /// - Returns: Контейнер для добавления отступов к компоненту.
    ///
    /// - SeeAlso: ``ComponentPadding``
    public nonisolated func padding(
        _ edge: Edge.Set,
        _ length: CGFloat
    ) -> Self {
        padding(EdgeInsets(edge, length))
    }

    /// Добавляет дополнительные отступы к текущим отступам контейнера.
    ///
    /// - Parameter length: Значение отступа для всех краев компонента.
    /// - Returns: Контейнер для добавления отступов к компоненту.
    ///
    /// - SeeAlso: ``ComponentPadding``
    public nonisolated func padding(_ length: CGFloat) -> Self {
        padding(EdgeInsets(all: length))
    }
}

extension View where Self: Equatable {

    /// Помещает компонент в контейнер с заданными отступами.
    ///
    /// - Parameter insets: Отступы, которые будут применены к компоненту.
    /// - Returns: Контейнер для добавления отступов к компоненту.
    ///
    /// - SeeAlso: ``ComponentPadding``
    public nonisolated func padding(_ insets: EdgeInsets) -> ComponentPadding<Self> {
        ComponentPadding(content: self, insets: insets)
    }

    /// Помещает компонент в контейнер с заданными отступами.
    ///
    /// - Parameters:
    ///   - top: Верхний отступ. По умолчанию равен `0.0`.
    ///   - leading: Ведущий отступ. По умолчанию равен `0.0`.
    ///   - bottom: Нижний отступ. По умолчанию равен `0.0`.
    ///   - trailing: Замыкающий отступ. По умолчанию равен `0.0`.
    /// - Returns: Контейнер для добавления отступов к компоненту.
    ///
    /// - SeeAlso: ``ComponentPadding``
    public nonisolated func padding(
        top: CGFloat = .zero,
        leading: CGFloat = .zero,
        bottom: CGFloat = .zero,
        trailing: CGFloat = .zero
    ) -> ComponentPadding<Self> {
        padding(
            EdgeInsets(
                top: top,
                leading: leading,
                bottom: bottom,
                trailing: trailing
            )
        )
    }

    /// Помещает компонент в контейнер с заданными отступами.
    ///
    /// - Parameters:
    ///   - edge: Набор краев, к которым будет применен отступ.
    ///   - length: Значение отступа.
    /// - Returns: Контейнер для добавления отступов к компоненту.
    ///
    /// - SeeAlso: ``ComponentPadding``
    public nonisolated func padding(
        _ edge: Edge.Set,
        _ length: CGFloat
    ) -> ComponentPadding<Self> {
        padding(EdgeInsets(edge, length))
    }

    /// Помещает компонент в контейнер с заданными отступами.
    ///
    /// - Parameter length: Значение отступа для всех краев компонента.
    /// - Returns: Контейнер для добавления отступов к компоненту.
    ///
    /// - SeeAlso: ``ComponentPadding``
    public nonisolated func padding(_ length: CGFloat) -> ComponentPadding<Self> {
        padding(EdgeInsets(all: length))
    }
}
#endif
