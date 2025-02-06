#if canImport(UIKit) && canImport(SafariServices)
import SafariServices

extension TokenViewProperties where View: SFSafariViewController {

    public var preferredBarTintColor: TokenViewProperty<ColorValue, Void> {
        property { view, value in
            view.preferredBarTintColor = value?.uiColor
        }
    }

    public var preferredControlTintColor: TokenViewProperty<ColorValue, Void> {
        property { view, value in
            view.preferredControlTintColor = value?.uiColor
        }
    }
}
#endif
