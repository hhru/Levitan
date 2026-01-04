#if canImport(UIKit)
import SwiftUI

/// Контейнер для добавления отступов к компонентам.
///
/// - SeeAlso: ``ComponentSizing``
/// - SeeAlso: ``Component``
public struct ComponentPadding<Content: Component> {

    /// Компонент, который будет обернут в контейнер.
    public let content: Content

    /// Отступы, которые будут применены к компоненту.
    public let insets: InsetsToken?

    /// Создает контейнер c отступами.
    ///
    /// - Parameters:
    ///   - content: Компонент, который будет обернут в контейнер.
    ///   - insets: Отступы, которые будут применены к компоненту.
    public init(
        content: Content,
        insets: InsetsToken?
    ) {
        self.content = content
        self.insets = insets
    }
}

extension ComponentPadding: Sendable where Content: Sendable { }
extension ComponentPadding: Hashable where Content: Hashable { }

extension ComponentPadding: View {

    public var body: some View {
        if let insets {
            content.padding(insets)
        } else {
            content
        }
    }
}

extension ComponentPadding: Component {

    public typealias UIView = ComponentPaddingView<Content>

    public func sizing(fitting size: CGSize, context: ComponentContext) -> ComponentSizing {
        let sizing = content.sizing(
            fitting: size,
            context: context
        )

        guard let insets = insets?.resolve(for: context.tokenTheme) else {
            return sizing
        }

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

extension Component {

    /// Помещает компонент в контейнер с заданными отступами.
    ///
    /// - Parameter insets: Отступы, которые будут применены к компоненту.
    /// - Returns: Контейнер для добавления отступов к компоненту.
    ///
    /// - SeeAlso: ``ComponentPadding``
    public nonisolated func padding(_ insets: InsetsToken?) -> some Component {
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
        top: SpacingToken = .zero,
        leading: SpacingToken = .zero,
        bottom: SpacingToken = .zero,
        trailing: SpacingToken = .zero
    ) -> some Component {
        padding(
            InsetsToken(
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
    ///   - value: Значение отступа.
    /// - Returns: Контейнер для добавления отступов к компоненту.
    ///
    /// - SeeAlso: ``ComponentPadding``
    public nonisolated func padding(_ edge: InsetsEdge, _ value: SpacingToken) -> some Component {
        padding(InsetsToken(edge, value))
    }

    /// Помещает компонент в контейнер с заданными отступами.
    ///
    /// - Parameter value: Значение отступа для всех краев компонента.
    /// - Returns: Контейнер для добавления отступов к компоненту.
    ///
    /// - SeeAlso: ``ComponentPadding``
    public nonisolated func padding(all value: SpacingToken?) -> some Component {
        padding(value.map(InsetsToken.init(all:)))
    }
}
#endif
