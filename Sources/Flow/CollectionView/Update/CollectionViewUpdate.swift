#if canImport(UIKit)
import Foundation

internal struct CollectionViewUpdate<Layout: FlowLayout> {

    internal let strategy: FlowUpdateStrategy

    internal let sections: [FlowSection<Layout>]
    internal let context: ComponentContext

    internal let completion: (@MainActor (_ skipped: Bool) -> Void)?
}
#endif
