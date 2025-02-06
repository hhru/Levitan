#if canImport(UIKit)
import UIKit

extension TokenViewProperties where View: UINavigationBar {

    public var backgroundImage: TokenViewProperty<ImageValue, BarPositionMetrics> {
        property(defaultDetails: .any) { view, value, details in
            view.setBackgroundImage(
                value?.uiImage,
                for: details.barPosition,
                barMetrics: details.barMetrics
            )
        }
    }

    public var barTintColor: TokenViewProperty<ColorValue, Void> {
        property { view, value in
            view.barTintColor = value?.uiColor
        }
    }

    public var shadowImage: TokenViewProperty<ImageValue, Void> {
        property { view, value in
            view.shadowImage = value?.uiImage
        }
    }

    public var titleTextAttributes: TokenViewProperty<TypographyValue, Void> {
        property { view, value in
            view.titleTextAttributes = value?.attributes ?? [:]
        }
    }

    #if os(iOS)
    public var largeTitleTextAttributes: TokenViewProperty<TypographyValue, Void> {
        property { view, value in
            view.largeTitleTextAttributes = value?.attributes ?? [:]
        }
    }

    public var backIndicatorImage: TokenViewProperty<ImageValue, Void> {
        property { view, value in
            view.backIndicatorImage = value?.uiImage
        }
    }

    public var backIndicatorTransitionMaskImage: TokenViewProperty<ImageValue, Void> {
        property { view, value in
            view.backIndicatorTransitionMaskImage = value?.uiImage
        }
    }
    #endif

    // TODO: implement for appearance
}
#endif
