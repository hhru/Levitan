#if canImport(UIKit)
import UIKit

extension UIImage {

    internal func cropped(to targetSize: CGSize) -> UIImage? {
        let format = UIGraphicsImageRendererFormat.default()

        format.scale = scale

        let renderer = UIGraphicsImageRenderer(size: targetSize, format: format)

        return renderer.image { _ in
            let widthDiff = size.width - targetSize.width
            let heightDiff = size.height - targetSize.height

            let drawOrigin = CGPoint(
                x: widthDiff.isZero ? .zero : -widthDiff / 2,
                y: heightDiff.isZero ? .zero : -heightDiff / 2
            )

            self.draw(at: drawOrigin)
        }
    }
}
#endif
