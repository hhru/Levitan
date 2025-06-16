#if canImport(UIKit) && os(iOS)
import UIKit

extension TokenViewProperties where View: UISlider {

    public var minimumValueImage: TokenViewProperty<ImageValue, Void> {
        property { view, value in
            view.minimumValueImage = value?.uiImage
        }
    }

    public var maximumValueImage: TokenViewProperty<ImageValue, Void> {
        property { view, value in
            view.maximumValueImage = value?.uiImage
        }
    }

    public var minimumTrackTintColor: TokenViewProperty<ColorValue, Void> {
        property { view, value in
            view.minimumTrackTintColor = value?.uiColor
        }
    }

    public var minimumTrackImage: TokenViewProperty<ImageValue, ControlState> {
        property(defaultDetails: .normal) { view, value, details in
            view.setMinimumTrackImage(value?.uiImage, for: details.state)
        }
    }

    public var maximumTrackTintColor: TokenViewProperty<ColorValue, Void> {
        property { view, value in
            view.maximumTrackTintColor = value?.uiColor
        }
    }

    public var maximumTrackImage: TokenViewProperty<ImageValue, ControlState> {
        property(defaultDetails: .normal) { view, value, details in
            view.setMaximumTrackImage(value?.uiImage, for: details.state)
        }
    }

    public var thumbTintColor: TokenViewProperty<ColorValue, Void> {
        property { view, value in
            view.thumbTintColor = value?.uiColor
        }
    }

    public var thumbImage: TokenViewProperty<ImageValue, ControlState> {
        property(defaultDetails: .normal) { view, value, details in
            view.setThumbImage(value?.uiImage, for: details.state)
        }
    }
}
#endif
