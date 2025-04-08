#if canImport(UIKit)
import Foundation

internal struct CollectionViewUpdate<Layout: ListLayout> {

    internal let strategy: ListUpdateStrategy

    internal let sections: [ListSection<Layout>]
    internal let context: ComponentContext

    internal let completion: (_ skipped: Bool) -> Void
}
#endif
