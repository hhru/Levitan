#if canImport(UIKit)
import Foundation

public enum ListLayoutAppearance {

    case custom(_ appearance: ListLayoutCustomAppearance)

    internal func configureItemForAppearing(
        _ item: inout ListLayoutItem,
        at indexPath: IndexPath
    ) {
        switch self {
        case let .custom(appearance):
            appearance.configureItemForAppearing(
                &item,
                at: indexPath
            )
        }
    }

    internal func configureItemForDisappearing(
        _ item: inout ListLayoutItem,
        at indexPath: IndexPath
    ) {
        switch self {
        case let .custom(appearance):
            appearance.configureItemForDisappearing(
                &item,
                at: indexPath
            )
        }
    }

    internal func configureHeaderForAppearing(
        _ header: inout ListLayoutHeader,
        at indexPath: IndexPath
    ) {
        switch self {
        case let .custom(appearance):
            appearance.configureHeaderForAppearing(
                &header,
                at: indexPath
            )
        }
    }

    internal func configureHeaderForDisappearing(
        _ header: inout ListLayoutHeader,
        at indexPath: IndexPath
    ) {
        switch self {
        case let .custom(appearance):
            appearance.configureHeaderForDisappearing(
                &header,
                at: indexPath
            )
        }
    }

    internal func configureFooterForAppearing(
        _ footer: inout ListLayoutFooter,
        at indexPath: IndexPath
    ) {
        switch self {
        case let .custom(appearance):
            appearance.configureFooterForAppearing(
                &footer,
                at: indexPath
            )
        }
    }

    internal func configureFooterForDisappearing(
        _ footer: inout ListLayoutFooter,
        at indexPath: IndexPath
    ) {
        switch self {
        case let .custom(appearance):
            appearance.configureFooterForDisappearing(
                &footer,
                at: indexPath
            )
        }
    }
}

extension ListLayoutAppearance: Equatable {

    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case let (.custom(lhs), .custom(rhs)):
            return lhs.isEqual(to: rhs)
        }
    }
}
#endif
