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

extension FallbackComponentBody {

    @MainActor
    private static func setupCoordinatorIfNeeded(_ coordinator: Coordinator, context: ComponentContext) {
        let nearestViewController = context.componentViewController ?? coordinator
            .view
            .superview?
            .next(of: UIViewController.self)

        let shouldIgnoreParentViewController = nearestViewController.map { viewController in
            viewController is UINavigationController
                || viewController is UITabBarController
                || viewController is UISplitViewController
        } ?? true

        let parentViewController = shouldIgnoreParentViewController
            ? nil
            : nearestViewController

        guard coordinator.parent !== parentViewController else {
            return
        }

        resetCoordinatorIfNeeded(coordinator)

        if let parentViewController {
            parentViewController.addChild(coordinator)
            coordinator.didMove(toParent: parentViewController)
        }
    }

    @MainActor
    private static func resetCoordinatorIfNeeded(_ coordinator: Coordinator) {
        guard coordinator.parent != nil else {
            return
        }

        coordinator.willMove(toParent: nil)
        coordinator.removeFromParent()
    }
}

extension FallbackComponentBody: UIViewRepresentable {

    public static func dismantleUIView(_ uiView: UIView, coordinator: Coordinator) {
        resetCoordinatorIfNeeded(coordinator)
    }

    public func makeCoordinator() -> FallbackComponentBodyCoordinator<Content> {
        Coordinator()
    }

    public func makeUIView(context: Context) -> UIView {
        context.coordinator.view
    }

    public func updateUIView(_ view: UIView, context: Context) {
        let coordinator = context.coordinator

        let context = context
            .environment
            .componentContext

        Self.setupCoordinatorIfNeeded(
            coordinator,
            context: context
        )

        coordinator.update(
            content: content,
            context: context
        )
    }

    @available(iOS 16.0, tvOS 16.0, *)
    public func sizeThatFits(
        _ proposal: ProposedViewSize,
        uiView: UIView,
        context: Context
    ) -> CGSize? {
        context.coordinator.sizeThatFits(
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

        let proposedWidth = children
            .first { $0.label == "width" }?
            .value as? CGFloat

        let proposedHeight = children
            .first { $0.label == "height" }?
            .value as? CGFloat

        let coordinator = uiView
            .next
            .flatMap { $0 as? Coordinator }

        size = coordinator?.sizeThatFits(
            proposedWidth: proposedWidth,
            proposedHeight: proposedHeight
        ) ?? size
    }
}
#endif
