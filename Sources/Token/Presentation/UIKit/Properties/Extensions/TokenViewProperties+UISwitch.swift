#if canImport(UIKit) && os(iOS)
import UIKit

extension TokenViewProperties where View: UISwitch {

    public var onTintColor: TokenViewProperty<ColorValue, Void> {
        property { view, value in
            view.onTintColor = value?.uiColor
        }
    }

    public var thumbTintColor: TokenViewProperty<ColorValue, Void> {
        property { view, value in
            view.thumbTintColor = value?.uiColor
        }
    }

    public var onImage: TokenViewProperty<ImageValue, Void> {
        property { view, value in
            view.onImage = value?.uiImage
        }
    }

    public var offImage: TokenViewProperty<ImageValue, Void> {
        property { view, value in
            view.offImage = value?.uiImage
        }
    }
}
#endif
