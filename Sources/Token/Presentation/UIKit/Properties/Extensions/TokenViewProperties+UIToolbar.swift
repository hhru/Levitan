#if os(iOS)
import UIKit

extension TokenViewProperties where View: UIToolbar {

    public var backgroundImage: TokenViewProperty<ImageValue, BarPositionMetrics> {
        property(defaultDetails: .any) { view, value, details in
            view.setBackgroundImage(
                value?.uiImage,
                forToolbarPosition: details.barPosition,
                barMetrics: details.barMetrics
            )
        }
    }

    public var shadowImage: TokenViewProperty<ImageValue, BarPosition> {
        property(defaultDetails: .any) { view, value, details in
            view.setShadowImage(
                value?.uiImage,
                forToolbarPosition: details.barPosition
            )
        }
    }

    public var barTintColor: TokenViewProperty<ColorValue, Void> {
        property { view, value in
            view.barTintColor = value?.uiColor
        }
    }

    // TODO: implement for appearance
}
#endif
