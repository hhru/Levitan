#if canImport(UIKit)
import UIKit
#else
import Foundation
#endif

import Combine

public final class TokenThemeManager: ObservableObject {

    #if canImport(UIKit)
    public static let `default` = TokenThemeManager()
    #endif

    private let storage: TokenThemeStorage
    private let resolver: TokenThemeResolver

    public var selectedThemeKey: TokenThemeKey? {
        storage.restoreSelectedThemeKey()
    }

    public var selectedThemeScheme: TokenThemeScheme? {
        storage.restoreSelectedThemeScheme()
    }

    @Published
    public private(set) var currentTheme: TokenTheme

    #if canImport(UIKit)
    public init(
        storage: TokenThemeStorage = DefaultTokenThemeStorage(),
        resolver: TokenThemeResolver = DefaultTokenThemeResolver()
    ) {
        self.storage = storage
        self.resolver = resolver

        currentTheme = resolver.resolveTheme(
            selectedKey: storage.restoreSelectedThemeKey(),
            selectedScheme: storage.restoreSelectedThemeScheme()
        )

        let traitsObservation = UIScreen.main.traitsObservation

        traitsObservation.registerObserver(self) { manager, traits, previousTraits in
            if traits.userInterfaceStyle != previousTraits?.userInterfaceStyle {
                manager.updateCurrentTheme()
            }
        }
    }
    #else
    public init(
        storage: TokenThemeStorage = DefaultTokenThemeStorage(),
        resolver: TokenThemeResolver
    ) {
        self.storage = storage
        self.resolver = resolver

        currentTheme = resolver.resolveTheme(
            selectedKey: storage.restoreSelectedThemeKey(),
            selectedScheme: storage.restoreSelectedThemeScheme()
        )
    }
    #endif

    private func updateCurrentTheme() {
        let theme = resolver.resolveTheme(
            selectedKey: selectedThemeKey,
            selectedScheme: selectedThemeScheme
        )

        if currentTheme != theme {
            currentTheme = theme
        }
    }

    public func selectTheme(key: TokenThemeKey) {
        storage.storeSelectedThemeKey(key)
        storage.storeSelectedThemeScheme(currentTheme.scheme)

        updateCurrentTheme()
    }

    public func selectTheme(scheme: TokenThemeScheme?) {
        storage.storeSelectedThemeKey(currentTheme.key)
        storage.storeSelectedThemeScheme(scheme)

        updateCurrentTheme()
    }

    public func selectTheme(
        key: TokenThemeKey,
        scheme: TokenThemeScheme?
    ) {
        storage.storeSelectedThemeKey(key)
        storage.storeSelectedThemeScheme(scheme)

        updateCurrentTheme()
    }
}
