#if canImport(UIKit)
import UIKit

public struct FlowReaderProxy<Layout: FlowLayout> {

    internal let flowViewProvider: @MainActor () -> FlowView<Layout>?

    @MainActor
    private var flowView: FlowView<Layout>? {
        flowViewProvider()
    }
}

extension FlowReaderProxy {

    @MainActor
    public func scrollToTop(animated: Bool = true) {
        flowView?.scrollToTop(animated: animated)
    }

    @MainActor
    public func scrollToBottom(animated: Bool = true) {
        flowView?.scrollToBottom(animated: animated)
    }

    @MainActor
    public func scrollToItem(
        at indexPath: IndexPath,
        anchor: FlowScrollAnchor? = nil,
        animated: Bool = true
    ) {
        flowView?.scrollToItem(
            at: indexPath,
            anchor: anchor,
            animated: animated
        )
    }

    @MainActor
    public func scrollToItem(
        where predicate: FlowItemPredicate,
        anchor: FlowScrollAnchor? = nil,
        animated: Bool = true
    ) {
        flowView?.scrollToItem(
            where: predicate,
            anchor: anchor,
            animated: animated
        )
    }

    @MainActor
    public func scrollToNextItem(
        after predicate: FlowItemPredicate,
        anchor: FlowScrollAnchor? = nil,
        animated: Bool = true
    ) {
        flowView?.scrollToNextItem(
            after: predicate,
            anchor: anchor,
            animated: animated
        )
    }

    @MainActor
    public func scrollToSection(
        where predicate: FlowSectionPredicate<Layout>,
        animated: Bool = true
    ) {
        flowView?.scrollToSection(
            where: predicate,
            animated: animated
        )
    }

    @MainActor
    public func scrollToNextSection(
        after predicate: FlowSectionPredicate<Layout>,
        animated: Bool = true
    ) {
        flowView?.scrollToNextSection(
            after: predicate,
            animated: animated
        )
    }

    @MainActor
    public func focusItem(where predicate: FlowItemPredicate) {
        flowView?.focusItem(where: predicate)
    }

    @MainActor
    public func focusNextItem(after predicate: FlowItemPredicate) {
        flowView?.focusNextItem(after: predicate)
    }

    @MainActor
    public func unfocusItem(where predicate: FlowItemPredicate) {
        flowView?.unfocusItem(where: predicate)
    }
}
#endif
