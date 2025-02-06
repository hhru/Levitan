#if canImport(UIKit)
import SwiftUI

public protocol ManualComponentModifier: ComponentModifier {

    func size<Content: ManualComponent>(
        content: Content,
        fitting size: CGSize,
        context: ComponentContext
    ) -> CGSize
}

extension ModifiedContent: ManualComponent where
    Content: ManualComponent,
    Modifier: ManualComponentModifier {

    public func size(
        fitting size: CGSize,
        context: ComponentContext
    ) -> CGSize {
        modifier.size(
            content: content,
            fitting: size,
            context: context
        )
    }
}
#endif
