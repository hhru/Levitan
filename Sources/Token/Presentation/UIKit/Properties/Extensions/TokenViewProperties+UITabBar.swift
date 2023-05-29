import UIKit

extension TokenViewProperties where View: UITabBar {

    public var backgroundImage: TokenViewProperty<ImageValue, Void> {
        property { view, value in
            view.backgroundImage = value?.uiImage
        }
    }

    public var selectionIndicatorImage: TokenViewProperty<ImageValue, Void> {
        property { view, value in
            view.selectionIndicatorImage = value?.uiImage
        }
    }

    public var shadowImage: TokenViewProperty<ImageValue, Void> {
        property { view, value in
            view.shadowImage = value?.uiImage
        }
    }

    public var unselectedItemTintColor: TokenViewProperty<ColorValue, Void> {
        property { view, value in
            view.unselectedItemTintColor = value?.uiColor
        }
    }

    public var barTintColor: TokenViewProperty<ColorValue, Void> {
        property { view, value in
            view.barTintColor = value?.uiColor
        }
    }

    // TODO: implement for appearance
}
