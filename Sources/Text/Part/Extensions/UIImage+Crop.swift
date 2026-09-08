#if canImport(UIKit)
import UIKit

extension UIImage {

    func crop(to targetSize: CGSize) -> UIImage? {
        let xCenter = (size.width - targetSize.width) / 2
        let yCenter = (size.height - targetSize.height) / 2
        let cropRect = CGRect(x: xCenter, y: yCenter, width: targetSize.width, height: targetSize.height)

        // Render the new clipped image
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { context in
            // Draw the original image offset so the target rect aligns with the context origin (0,0)
            let drawRect = CGRect(
                x: -cropRect.origin.x,
                y: -cropRect.origin.y,
                width: size.width,
                height: size.height
            )
            draw(in: drawRect)
        }
    }
}

#endif
