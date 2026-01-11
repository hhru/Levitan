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

    internal let content: Content
}

private let componentContextAssociation = ObjectAssociation<ComponentContext>()

extension FallbackComponentBody: UIViewRepresentable {

    public func makeUIView(context: Context) -> Content.UIView {
        Logger.debug(
            ["\(Self.self).\(#function)"],
            ["id:", context.environment.componentIdentifier ?? "nil"],
            subsystem: "Component",
            category: "FallbackComponentBody"
        )

        return Content.UIView()
    }

    public func updateUIView(_ view: Content.UIView, context: Context) {
        Logger.debug(
            ["\(Self.self).\(#function)"],
            ["id:", context.environment.componentIdentifier ?? "nil"],
            subsystem: "Component",
            category: "FallbackComponentBody"
        )

        let cache = context.environment.fallbackComponentCache

        let context = context
            .environment
            .componentContext
            .componentLayoutInvalidation { [weak cache] in
                cache?.resetSize(for: content)
            }

        componentContextAssociation[view] = context

        view.tokens.themeKey(context.tokenThemeKey)
        view.tokens.themeScheme(context.tokenThemeScheme)

        view.update(with: content, context: context)
    }

    @available(iOS 16.0, tvOS 16.0, *)
    public func sizeThatFits(
        _ proposal: ProposedViewSize,
        uiView: Content.UIView,
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

        let context = context
            .environment
            .componentContext

        let size = size(
            for: uiView,
            proposedWidth: proposal.width,
            proposedHeight: proposal.height,
            context: context
        )

        Logger.debug(
            ["\(Self.self).\(#function) -- END"],
            ["size:", size],
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
        uiView: Content.UIView
    ) {
        let children = Mirror(reflecting: proposedSize).children

        let proposedWidth = children
            .first { $0.label == "width" }?
            .value as? CGFloat

        let proposedHeight = children
            .first { $0.label == "height" }?
            .value as? CGFloat

        Logger.debug(
            ["\(Self.self).\(#function)"],
            ["proposedWidth:", proposedWidth ?? "nil"],
            ["proposedHeight:", proposedHeight ?? "nil"],
            subsystem: "Component",
            category: "FallbackComponentBody"
        )

        guard let context = componentContextAssociation[uiView] else {
            return
        }

        size = self.size(
            for: uiView,
            proposedWidth: proposedWidth,
            proposedHeight: proposedHeight,
            context: context
        )

        Logger.debug(
            ["\(Self.self).\(#function) -- END"],
            ["size:", size],
            subsystem: "Component",
            category: "FallbackComponentBody"
        )
    }
}

extension FallbackComponentBody {

    @MainActor
    private func size(
        for view: UIView,
        proposedWidth: CGFloat?,
        proposedHeight: CGFloat?,
        context: ComponentContext
    ) -> CGSize {
        // Считаем идеальные размеры как минимальные
        let proposedSize = CGSize(
            width: proposedWidth ?? .zero,
            height: proposedHeight ?? .zero
        )

        // Для получения идеальных размеров не ограничиваем стратегии
        let boundingSize = CGSize(
            width: proposedWidth ?? .infinity,
            height: proposedHeight ?? .infinity
        )

        return size(
            for: view,
            proposedSize: proposedSize,
            boundingSize: boundingSize,
            context: context
        )
    }

    @MainActor
    private func size(
        for view: UIView,
        proposedSize: CGSize,
        boundingSize: CGSize,
        context: ComponentContext
    ) -> CGSize {
        let cache = context
            .fallbackComponentCache
            .value

        let cacheSize = cache?.restoreSize(
            for: content,
            proposedSize: proposedSize,
            boundingSize: boundingSize
        )

        if let size = cacheSize {
            return size
        }

        let sizing = content.sizing(
            fitting: boundingSize,
            context: context
        )

        let size = size(
            for: view,
            proposedSize: proposedSize,
            sizing: sizing
        )

        cache?.storeSize(
            for: content,
            size: size,
            sizing: sizing,
            proposedSize: proposedSize,
            boundingSize: boundingSize
        )

        return size
    }

    @MainActor
    // swiftlint:disable:next function_body_length
    private func size(for view: UIView, proposedSize: CGSize, sizing: ComponentSizing) -> CGSize {
        switch (sizing.width, sizing.height) {
        case let (.fixed(fixedWidth), .fixed(fixedHeight)):
            view.sizeWithFixedWidthAndFixedHeight(
                width: fixedWidth,
                height: fixedHeight
            )

        case let (.fixed(fixedWidth), .hug):
            view.sizeWithFixedWidthAndHuggingHeight(
                width: fixedWidth,
                containerHeight: proposedSize.height,
                maxHeight: proposedSize.height
            )

        case let (.fixed(fixedWidth), .fill):
            view.sizeWithFixedWidthAndFillingHeight(
                width: fixedWidth,
                containerHeight: proposedSize.height
            )

        case let (.hug, .fixed(fixedHeight)):
            view.sizeWithHuggingWidthAndFixedHeight(
                containerWidth: proposedSize.width,
                maxWidth: proposedSize.width,
                height: fixedHeight
            )

        case (.hug, .hug):
            view.sizeWithHuggingWidthAndHuggingHeight(
                containerWidth: proposedSize.width,
                maxWidth: proposedSize.width,
                containerHeight: proposedSize.height,
                maxHeight: proposedSize.height
            )

        case (.hug, .fill):
            view.sizeWithHuggingWidthAndFillingHeight(
                containerWidth: proposedSize.width,
                maxWidth: proposedSize.width,
                containerHeight: proposedSize.height
            )

        case let (.fill, .fixed(fixedHeight)):
            view.sizeWithFillingWidthAndFixedHeight(
                containerWidth: proposedSize.width,
                height: fixedHeight
            )

        case (.fill, .hug):
            view.sizeWithFillingWidthAndHuggingHeight(
                containerWidth: proposedSize.width,
                containerHeight: proposedSize.height,
                maxHeight: proposedSize.height
            )

        case (.fill, .fill):
            view.sizeWithFillingWidthAndFillingHeight(
                containerWidth: proposedSize.width,
                containerHeight: proposedSize.height
            )
        }
    }
}

#endif
