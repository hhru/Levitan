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
public struct FallbackComponentBody<Content: FallbackComponent> {

    public let content: Content
}

extension FallbackComponentBody: UIViewRepresentable {

    public typealias UIView = FallbackComponentBodyView<Content>

    public static func dismantleUIView(_ view: UIView, coordinator: Coordinator) {
        view.dismantle()
    }

    public func makeUIView(context: Context) -> UIView {
        let cache = context.environment.fallbackComponentViewCache

        guard let view = cache.restoreView(for: Content.self) else {
            return UIView()
        }

        return view
    }

    public func updateUIView(_ view: UIView, context: Context) {
        let environment = context.environment

        let context = ComponentContext(
            environment: environment,
            overrides: [:]
        )

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
        uiView.layout(
            proposedWidth: proposal.width,
            proposedHeight: proposal.height
        )
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

        size = uiView.layout(
            proposedWidth: proposalWidth,
            proposedHeight: proposalHeight
        ) ?? size
    }
}
#endif
