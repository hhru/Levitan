#if canImport(UIKit)
import Foundation

internal struct CollectionViewState<Layout: FlowLayout> {

    internal let sections: [FlowSection<Layout>]
    internal let context: ComponentContext?

    internal func section(at index: Int) -> FlowSection<Layout>? {
        sections[safe: index]
    }

    internal func section(at indexPath: IndexPath) -> FlowSection<Layout>? {
        section(at: indexPath.section)
    }

    internal func item(at indexPath: IndexPath) -> FlowSectionItem? {
        sections[safe: indexPath.section]?.items[safe: indexPath.item]
    }

    internal func header(at index: Int) -> FlowSectionHeader? {
        sections[safe: index]?.header
    }

    internal func header(at indexPath: IndexPath) -> FlowSectionHeader? {
        header(at: indexPath.section)
    }

    internal func footer(at index: Int) -> FlowSectionFooter? {
        sections[safe: index]?.footer
    }

    internal func footer(at indexPath: IndexPath) -> FlowSectionFooter? {
        footer(at: indexPath.section)
    }

    internal func metrics(at index: Int) -> Layout.Metrics? {
        sections[safe: index]?.metrics
    }

    internal func metrics(at indexPath: IndexPath) -> Layout.Metrics? {
        metrics(at: indexPath.section)
    }
}

extension CollectionViewState {

    internal static var empty: Self {
        Self(
            sections: [],
            context: nil
        )
    }
}
#endif
