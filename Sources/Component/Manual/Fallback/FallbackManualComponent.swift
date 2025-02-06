#if canImport(UIKit1)
import Foundation

/// Частный случай `FallbackComponent` для UIKit-компонентов, который используют только стратегию
/// с фиксированным размером.
///
/// - SeeAlso ``FallbackComponent``
public protocol FallbackManualComponent: ManualComponent, FallbackComponent
where UIView: FallbackManualComponentView { }

extension FallbackManualComponent {

    public func size(
        fitting size: CGSize,
        context: ComponentContext
    ) -> CGSize {
        UIView.size(
            for: self,
            fitting: size,
            context: context
        )
    }
}
#endif
