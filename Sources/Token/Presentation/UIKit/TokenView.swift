#if canImport(UIKit)
import UIKit

internal protocol TokenView: AnyTokenView {

    var tokenViewRoot: TokenView? { get }
    var tokenViewParent: TokenView? { get }
    var tokenViewChildren: [TokenView] { get }

    var shouldAlwaysOverrideUserInterfaceStyle: Bool { get }

    func overrideUserInterfaceStyle(themeScheme: TokenThemeScheme)
}

@MainActor
private let tokenViewPayloadAssociation = {
    Task { @MainActor in
        UIWindowScene.handleTokenViewEvents()
        UIView.handleTokenViewEvents()
        CALayer.handleTokenViewEvents()
    }

    return ObjectAssociation<TokenViewPayload>()
}()

extension TokenView {

    internal var shouldAlwaysOverrideUserInterfaceStyle: Bool {
        false
    }

    internal var tokenViewPayloadIfExists: TokenViewPayload? {
        tokenViewPayloadAssociation[self]
    }

    internal var tokenViewPayload: TokenViewPayload {
        if let viewPayload = tokenViewPayloadAssociation[self] {
            return viewPayload
        }

        let viewPayload = TokenViewPayload()

        tokenViewPayloadAssociation[self] = viewPayload

        return viewPayload
    }

    public var tokenViewManager: TokenViewManager {
        TokenViewManager(view: self)
    }
}
#endif
