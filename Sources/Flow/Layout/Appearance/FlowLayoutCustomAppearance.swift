#if canImport(UIKit)
import Foundation

public protocol FlowLayoutCustomAppearance: Sendable {

    @MainActor
    func configureItemForAppearing(
        _ item: inout FlowLayoutItem,
        at indexPath: IndexPath
    )

    @MainActor
    func configureItemForDisappearing(
        _ item: inout FlowLayoutItem,
        at indexPath: IndexPath
    )

    @MainActor
    func configureHeaderForAppearing(
        _ header: inout FlowLayoutHeader,
        at indexPath: IndexPath
    )

    @MainActor
    func configureHeaderForDisappearing(
        _ header: inout FlowLayoutHeader,
        at indexPath: IndexPath
    )

    @MainActor
    func configureFooterForAppearing(
        _ footer: inout FlowLayoutFooter,
        at indexPath: IndexPath
    )

    @MainActor
    func configureFooterForDisappearing(
        _ footer: inout FlowLayoutFooter,
        at indexPath: IndexPath
    )

    func isEqual(to other: FlowLayoutCustomAppearance) -> Bool
}

extension FlowLayoutCustomAppearance where Self: Equatable {

    public func isEqual(to other: FlowLayoutCustomAppearance) -> Bool {
        guard let other = other as? Self else {
            return false
        }

        return self == other
    }
}
#endif
