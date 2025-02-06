#if canImport(UIKit1)
import UIKit

extension TokenViewProperties where View: UIActivityIndicatorView {

    public var color: TokenViewProperty<ColorValue, Void> {
        property { view, value in
            view.color = value?.uiColor
        }
    }
}
#endif
