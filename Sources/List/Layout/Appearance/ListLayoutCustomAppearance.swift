#if canImport(UIKit)
import Foundation

public protocol ListLayoutCustomAppearance {

    func configureItemForAppearing(
        _ item: inout ListLayoutItem,
        at indexPath: IndexPath
    )

    func configureItemForDisappearing(
        _ item: inout ListLayoutItem,
        at indexPath: IndexPath
    )

    func configureHeaderForAppearing(
        _ header: inout ListLayoutHeader,
        at indexPath: IndexPath
    )

    func configureHeaderForDisappearing(
        _ header: inout ListLayoutHeader,
        at indexPath: IndexPath
    )

    func configureFooterForAppearing(
        _ footer: inout ListLayoutFooter,
        at indexPath: IndexPath
    )

    func configureFooterForDisappearing(
        _ footer: inout ListLayoutFooter,
        at indexPath: IndexPath
    )

    func isEqual(to other: ListLayoutCustomAppearance) -> Bool
}

extension ListLayoutCustomAppearance where Self: Equatable {

    public func isEqual(to other: ListLayoutCustomAppearance) -> Bool {
        guard let other = other as? Self else {
            return false
        }

        return self == other
    }
}
#endif
