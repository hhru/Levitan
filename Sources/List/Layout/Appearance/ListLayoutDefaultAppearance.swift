import Foundation

public struct ListLayoutDefaultAppearance: Equatable, ListLayoutCustomAppearance {

    public func configureItemForAppearing(
        _ item: inout ListLayoutItem,
        at indexPath: IndexPath
    ) {
        item.alpha = .zero
    }

    public func configureItemForDisappearing(
        _ item: inout ListLayoutItem,
        at indexPath: IndexPath
    ) {
        item.alpha = .zero
    }

    public func configureHeaderForAppearing(
        _ header: inout ListLayoutHeader,
        at indexPath: IndexPath
    ) {
        header.alpha = .zero
    }

    public func configureHeaderForDisappearing(
        _ header: inout ListLayoutHeader,
        at indexPath: IndexPath
    ) {
        header.alpha = .zero
    }

    public func configureFooterForAppearing(
        _ footer: inout ListLayoutFooter,
        at indexPath: IndexPath
    ) {
        footer.alpha = .zero
    }

    public func configureFooterForDisappearing(
        _ footer: inout ListLayoutFooter,
        at indexPath: IndexPath
    ) {
        footer.alpha = .zero
    }
}

extension ListLayoutAppearance {

    public static var `default`: Self {
        custom(ListLayoutDefaultAppearance())
    }
}
