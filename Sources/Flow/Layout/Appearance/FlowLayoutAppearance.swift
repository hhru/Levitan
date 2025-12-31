#if canImport(UIKit)
import Foundation

public enum FlowLayoutAppearance: Sendable {

    case custom(_ appearance: FlowLayoutCustomAppearance)

    @MainActor
    internal func configureItemForAppearing(
        _ item: inout FlowLayoutItem,
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

    @MainActor
    internal func configureItemForDisappearing(
        _ item: inout FlowLayoutItem,
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

    @MainActor
    internal func configureHeaderForAppearing(
        _ header: inout FlowLayoutHeader,
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

    @MainActor
    internal func configureHeaderForDisappearing(
        _ header: inout FlowLayoutHeader,
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

    @MainActor
    internal func configureFooterForAppearing(
        _ footer: inout FlowLayoutFooter,
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

    @MainActor
    internal func configureFooterForDisappearing(
        _ footer: inout FlowLayoutFooter,
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

extension FlowLayoutAppearance: Equatable {

    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case let (.custom(lhs), .custom(rhs)):
            return lhs.isEqual(to: rhs)
        }
    }
}
#endif
