#if canImport(UIKit)
import UIKit

extension TokenViewProperties where View: UIProgressView {

    public var progressTintColor: TokenViewProperty<ColorValue, Void> {
        property { view, value in
            view.progressTintColor = value?.uiColor
        }
    }

    public var progressImage: TokenViewProperty<ImageValue, Void> {
        property { view, value in
            view.progressImage = value?.uiImage
        }
    }

    public var trackTintColor: TokenViewProperty<ColorValue, Void> {
        property { view, value in
            view.trackTintColor = value?.uiColor
        }
    }

    public var trackImage: TokenViewProperty<ImageValue, Void> {
        property { view, value in
            view.trackImage = value?.uiImage
        }
    }
}
#endif
