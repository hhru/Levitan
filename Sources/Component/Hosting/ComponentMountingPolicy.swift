#if canImport(UIKit)
import Foundation

/// Политика монтирования SwiftUI-компонентов в UIKit-представление.
///
/// Определяет момент, в который ``ComponentHostingView`` встраивает `UIHostingController`
/// по умолчанию ``deferred``
///
/// - SeeAlso: ``Component``
/// - SeeAlso: ``ComponentContext``
public enum ComponentMountingPolicy: Hashable, Sendable {

    /// Монтирование откладывается до попадания представления в иерархию окна.
    ///
    /// Гарантирует наличие экземпляра `UIViewController` в контексте или в цепочке `UIResponder`
    /// на момент встраивания, поэтому используется по умолчанию.
    ///
    /// До монтирования представление не сообщает размер контента:
    /// его `intrinsicContentSize` содержит `UIView.noIntrinsicMetric`.
    case deferred

    /// Монтирование выполняется сразу при обновлении контента, не дожидаясь иерархии окна.
    ///
    /// Вне иерархии окна родительский `UIViewController` не резолвится,
    /// поэтому контроллер встраивается без него, а при попадании в иерархию окна
    /// выполняется его повторное встраивание уже с родителем.
    case eager
}
#endif
