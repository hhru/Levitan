import Foundation

public struct TokenViewManager {

    internal let view: TokenView

    internal var theme: TokenTheme {
        let viewPayload = view.tokenViewPayloadIfExists

        return viewPayload?.theme
            ?? viewPayload?.themeManager?.currentTheme
            ?? inheritedTheme(of: view)
    }

    internal var themeManager: TokenThemeManager? {
        view
            .tokenViewPayloadIfExists?
            .themeManager ?? inheritedThemeManager(of: view)
    }

    private func defaultTheme(of view: TokenView) -> TokenTheme {
        if let theme = view.tokenViewRoot?.tokenViewPayloadIfExists?.theme {
            return theme
        }

        return TokenTheme(key: .default, scheme: .light)
    }

    private func inheritedTheme(of view: TokenView) -> TokenTheme {
        guard let parentView = view.tokenViewParent else {
            return defaultTheme(of: view)
        }

        if let parentViewPayload = parentView.tokenViewPayloadIfExists {
            return parentViewPayload.theme ?? defaultTheme(of: view)
        }

        return inheritedTheme(of: parentView)
    }

    private func inheritedThemeManager(of view: TokenView) -> TokenThemeManager? {
        guard let parentView = view.tokenViewParent else {
            return nil
        }

        if let themeManager = parentView.tokenViewPayloadIfExists?.themeManager {
            return themeManager
        }

        return inheritedThemeManager(of: parentView)
    }

    private func updateView(viewPayload: TokenViewPayload) {
        guard let theme = viewPayload.theme else {
            return
        }

        for binding in viewPayload.propertyBindings {
            binding.value.handle(view: view, theme: theme)
        }

        for binding in viewPayload.customBindings {
            binding.handle(view: view, theme: theme)
        }
    }

    private func updateHierarchyTheme(with theme: TokenTheme, from childView: TokenView) {
        let viewPayload = childView.tokenViewPayloadIfExists

        guard viewPayload?.themeManager == nil else {
            return
        }

        childView.tokenViewManager.updateTheme(
            with: theme,
            viewPayload: viewPayload
        )
    }

    private func updateHierarchyTheme(with theme: TokenTheme) {
        for childView in view.tokenViewChildren {
            updateHierarchyTheme(with: theme, from: childView)
        }
    }

    private func updateTheme(with theme: TokenTheme, viewPayload: TokenViewPayload?) {
        let themeScheme = viewPayload?.themeScheme ?? theme.scheme
        let themeKey = viewPayload?.themeKey ?? theme.key

        let shouldOverrideUserInterfaceStyle = view.shouldAlwaysOverrideUserInterfaceStyle
            || viewPayload?.themeManager != nil
            || viewPayload?.themeScheme != nil

        if shouldOverrideUserInterfaceStyle {
            view.overrideUserInterfaceStyle(themeScheme: themeScheme)
        }

        guard let viewPayload else {
            return updateHierarchyTheme(with: theme)
        }

        let theme = TokenTheme(
            key: themeKey,
            scheme: themeScheme
        )

        guard viewPayload.theme != theme else {
            return
        }

        viewPayload.theme = theme

        updateHierarchyTheme(with: theme)
        updateView(viewPayload: viewPayload)
    }

    internal func updateTheme() {
        let viewPayload = view.tokenViewPayloadIfExists

        if let theme = viewPayload?.themeManager?.currentTheme {
            updateTheme(with: theme, viewPayload: viewPayload)
        } else {
            updateTheme(
                with: inheritedTheme(of: view),
                viewPayload: viewPayload
            )
        }
    }

    internal func themeManager(_ themeManager: TokenThemeManager?) {
        guard view.tokenViewPayloadIfExists?.themeManager !== themeManager else {
            return
        }

        let viewPayload = view.tokenViewPayload

        viewPayload.themeManager = themeManager

        viewPayload.themeSubscription = themeManager?
            .$currentTheme
            .sink { [weak view, weak viewPayload] theme in
                view?.tokenViewManager.updateTheme(
                    with: theme,
                    viewPayload: viewPayload
                )
            }

        updateTheme()
    }

    internal func themeKey(_ themeKey: TokenThemeKey?) {
        guard view.tokenViewPayloadIfExists?.themeKey != themeKey else {
            return
        }

        view
            .tokenViewPayload
            .themeKey = themeKey

        updateTheme()
    }

    internal func themeScheme(_ themeScheme: TokenThemeScheme?) {
        guard view.tokenViewPayloadIfExists?.themeScheme != themeScheme else {
            return
        }

        view
            .tokenViewPayload
            .themeScheme = themeScheme

        updateTheme()
    }

    internal func customBinding<View>(
        handler: @escaping (
            _ view: View,
            _ theme: TokenTheme
        ) -> Void
    ) -> TokenViewCustomBinding {
        let binding = TokenViewCustomBinding(handler: handler)
        let viewPayload = view.tokenViewPayload

        viewPayload
            .customBindings
            .append(binding)

        if let theme = viewPayload.theme {
            binding.handle(view: view, theme: theme)
        } else {
            updateTheme()
        }

        return binding
    }

    internal func propertyBinding<Value>(
        at key: AnyHashable,
        handler: @escaping (
            _ view: TokenView,
            _ value: Value?,
            _ theme: TokenTheme
        ) -> Void
    ) -> TokenViewPropertyBinding<Value> {
        let viewPayload = view.tokenViewPayload

        if let binding = viewPayload.propertyBindings[key] as? TokenViewPropertyBinding<Value> {
            return binding
        }

        let binding = TokenViewPropertyBinding(handler: handler) { [weak view] in
            guard let view else {
                return
            }

            let viewPayload = view.tokenViewPayload

            if let theme = viewPayload.theme {
                viewPayload
                    .propertyBindings[key]?
                    .handle(view: view, theme: theme)
            } else {
                view.tokenViewManager.updateTheme()
            }
        }

        viewPayload.propertyBindings[key] = binding

        return binding
    }
}
