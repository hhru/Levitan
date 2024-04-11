import Foundation

internal struct CollectionViewState<Layout: ListLayout> {

    internal let sections: [ListSection<Layout>]
    internal let context: ComponentContext?

    internal func section(at indexPath: IndexPath) -> ListSection<Layout>? {
        sections[safe: indexPath.section]
    }

    internal func item(at indexPath: IndexPath) -> ListSectionItem? {
        sections[safe: indexPath.section]?.items[safe: indexPath.item]
    }

    internal func header(at index: Int) -> ListSectionHeader? {
        sections[safe: index]?.header
    }

    internal func footer(at index: Int) -> ListSectionFooter? {
        sections[safe: index]?.footer
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
