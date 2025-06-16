#if canImport(UIKit)
import UIKit
#else
import Foundation
#endif

import Combine

public final class TokenThemeManager: ObservableObject {

    #if canImport(UIKit)
    @MainActor
    public static var `default`: TokenThemeManager {
        TokenThemeManager()
    }
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
    @MainActor
    public init(
        storage: TokenThemeStorage = DefaultTokenThemeStorage(),
        resolver: TokenThemeResolver? = nil
    ) {
        self.storage = storage
        self.resolver = resolver ?? DefaultTokenThemeResolver()

        currentTheme = self.resolver.resolveTheme(
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
    @MainActor
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

    @MainActor
    private func updateCurrentTheme() {
        let theme = resolver.resolveTheme(
            selectedKey: selectedThemeKey,
            selectedScheme: selectedThemeScheme
        )

        if currentTheme != theme {
            currentTheme = theme
        }
    }

    @MainActor
    public func selectTheme(key: TokenThemeKey) {
        storage.storeSelectedThemeKey(key)
        storage.storeSelectedThemeScheme(currentTheme.scheme)

        updateCurrentTheme()
    }

    @MainActor
    public func selectTheme(scheme: TokenThemeScheme?) {
        storage.storeSelectedThemeKey(currentTheme.key)
        storage.storeSelectedThemeScheme(scheme)

        updateCurrentTheme()
    }

    @MainActor
    public func selectTheme(
        key: TokenThemeKey,
        scheme: TokenThemeScheme?
    ) {
        storage.storeSelectedThemeKey(key)
        storage.storeSelectedThemeScheme(scheme)

        updateCurrentTheme()
    }
}
