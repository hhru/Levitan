#if canImport(UIKit)
import SwiftUI

/// SwiftUI-представление для UIKit-компонентов.
///
/// Используется в качестве универсальной реализации протокола `UIViewRepresentable`,
/// которая создает и обновляет UIKit-представление компонента, определяет его размеры
/// и синхронизирует контекст со SwiftUI-окружением.
///
/// - SeeAlso: ``FallbackComponent``
/// - SeeAlso: ``FallbackComponentView``
/// - SeeAlso: ``ComponentContext``
public struct FallbackComponentBody<Content: FallbackComponent>: UIViewRepresentable {

    public typealias UIView = FallbackComponentBodyView<Content>

    public let content: Content

    public func makeUIView(context: Context) -> UIView {
        Logger.debug(
            ["\(Self.self).\(#function)"],
            ["id:", context.environment.componentIdentifier ?? "nil"],
            subsystem: "Component",
            category: "FallbackComponentBody"
        )

        return UIView()
    }

    public func updateUIView(_ view: UIView, context: Context) {
        Logger.debug(
            ["\(Self.self).\(#function)"],
            ["id:", context.environment.componentIdentifier ?? "nil"],
            subsystem: "Component",
            category: "FallbackComponentBody"
        )

        let context = context
            .environment
            .componentContext

        view.update(
            with: content,
            context: context
        )
    }

    @available(iOS 16.0, tvOS 16.0, *)
    public func sizeThatFits(
        _ proposal: ProposedViewSize,
        uiView: UIView,
        context: Context
    ) -> CGSize? {
        Logger.debug(
            ["\(Self.self).\(#function)"],
            ["id:", context.environment.componentIdentifier ?? "nil"],
            ["proposalWidth:", proposal.width ?? "nil"],
            ["proposalHeight:", proposal.height ?? "nil"],
            subsystem: "Component",
            category: "FallbackComponentBody"
        )

        let size = uiView.layout(
            proposedWidth: proposal.width,
            proposedHeight: proposal.height
        )

        Logger.debug(
            ["\(Self.self).\(#function) -- END"],
            ["size:", size ?? "nil"],
            subsystem: "Component",
            category: "FallbackComponentBody"
        )

        return size
    }

    /// Приватное API для определения размеров.
    ///
    /// Аналогичен методу `sizeThatFits(_:uiView:context:)`, который доступен только c iOS 16.
    /// По сути является переопределением стандартного способа определения размеров в SwiftUI,
    /// который используется, если метод `sizeThatFits(_:uiView:context:)` вернул `nil`,
    /// что в текущей реализации является невозможным.
    ///
    /// Безопасен для релизов в AppStore, так как API стало публичным в актуальных версиях iOS.
    /// Также подобная реализация используется и в других OpenSource решениях:
    /// https://github.com/search?q=_overrideSizeThatFits&type=code
    ///
    /// Для получения предалагаемых размеров используется рефлексия,
    /// так как тип `_ProposedSize` так же является приватным, и его поля недоступны.
    public func _overrideSizeThatFits(
        _ size: inout CGSize,
        in proposedSize: _ProposedSize,
        uiView: UIView
    ) {
        let children = Mirror(reflecting: proposedSize).children

        let proposalWidth = children
            .first { $0.label == "width" }?
            .value as? CGFloat

        let proposalHeight = children
            .first { $0.label == "height" }?
            .value as? CGFloat

        Logger.debug(
            ["\(Self.self).\(#function)"],
            ["proposalWidth:", proposalWidth ?? "nil"],
            ["proposalHeight:", proposalHeight ?? "nil"],
            subsystem: "Component",
            category: "FallbackComponentBody"
        )

        size = uiView.layout(
            proposedWidth: proposalWidth,
            proposedHeight: proposalHeight
        ) ?? size

        Logger.debug(
            ["\(Self.self).\(#function) -- END"],
            ["size:", size],
            subsystem: "Component",
            category: "FallbackComponentBody"
        )
    }
}
#endif
