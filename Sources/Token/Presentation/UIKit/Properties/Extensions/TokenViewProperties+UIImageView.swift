import UIKit

extension TokenViewProperties where View: UIImageView {

    public var image: TokenViewProperty<ImageValue, Void> {
        property { view, value in
            view.image = value?.uiImage
        }
    }

    public var highlightedImage: TokenViewProperty<ImageValue, Void> {
        property { view, value in
            view.highlightedImage = value?.uiImage
        }
    }

    public var animationImages: TokenViewProperty<[ImageValue], Void> {
        property { view, value in
            view.animationImages = value?.map { $0.uiImage }
        }
    }

    public var highlightedAnimationImages: TokenViewProperty<[ImageValue], Void> {
        property { view, value in
            view.highlightedAnimationImages = value?.map { $0.uiImage }
        }
    }
}
