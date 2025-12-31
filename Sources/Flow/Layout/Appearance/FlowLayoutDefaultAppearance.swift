#if canImport(UIKit)
import Foundation

public struct FlowLayoutDefaultAppearance: FlowLayoutCustomAppearance, Equatable {

    public func configureItemForAppearing(
        _ item: inout FlowLayoutItem,
        at indexPath: IndexPath
    ) {
        item.alpha = .zero
    }

    public func configureItemForDisappearing(
        _ item: inout FlowLayoutItem,
        at indexPath: IndexPath
    ) {
        item.alpha = .zero
    }

    public func configureHeaderForAppearing(
        _ header: inout FlowLayoutHeader,
        at indexPath: IndexPath
    ) {
        header.alpha = .zero
    }

    public func configureHeaderForDisappearing(
        _ header: inout FlowLayoutHeader,
        at indexPath: IndexPath
    ) {
        header.alpha = .zero
    }

    public func configureFooterForAppearing(
        _ footer: inout FlowLayoutFooter,
        at indexPath: IndexPath
    ) {
        footer.alpha = .zero
    }

    public func configureFooterForDisappearing(
        _ footer: inout FlowLayoutFooter,
        at indexPath: IndexPath
    ) {
        footer.alpha = .zero
    }
}

extension FlowLayoutAppearance {

    public static var `default`: Self {
        custom(FlowLayoutDefaultAppearance())
    }
}
#endif
