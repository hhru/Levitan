#if canImport(UIKit)
import UIKit

extension TokenViewProperties where View: UIButton {

    public var titleColor: TokenViewProperty<ColorValue, ControlState> {
        property(defaultDetails: .normal) { view, value, details in
            view.setTitleColor(value?.uiColor, for: details.state)
        }
    }

    public var titleShadowColor: TokenViewProperty<ColorValue, ControlState> {
        property(defaultDetails: .normal) { view, value, details in
            view.setTitleShadowColor(value?.uiColor, for: details.state)
        }
    }

    public var image: TokenViewProperty<ImageValue, ControlState> {
        property(defaultDetails: .normal) { view, value, details in
            view.setImage(value?.uiImage, for: details.state)
        }
    }

    public var backgroundImage: TokenViewProperty<ImageValue, ControlState> {
        property(defaultDetails: .normal) { view, value, details in
            view.setBackgroundImage(value?.uiImage, for: details.state)
        }
    }
}
#endif
