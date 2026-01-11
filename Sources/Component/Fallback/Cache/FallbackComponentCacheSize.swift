#if canImport(UIKit)
import CoreGraphics
import Foundation

internal struct FallbackComponentCacheSize: Hashable {

    internal let targetSize: CGSize

    internal let contentSize: CGSize
    internal let contentSizing: ComponentSizing

    private let minReuseSize: CGSize

    internal init(
        targetSize: CGSize,
        contentSize: CGSize,
        contentSizing: ComponentSizing
    ) {
        self.targetSize = targetSize

        self.contentSize = contentSize
        self.contentSizing = contentSizing

        minReuseSize = CGSize(
            width: min(targetSize.width, contentSize.width),
            height: min(targetSize.height, contentSize.height)
        )
    }

    /// Получает итоговые размеры компонента, которые соответствуют целевым.
    ///
    /// SwiftUI слишком расстачительно определяет размеры, повторно запрашивая уже известные
    /// или предлагая неразумные размеры, например, ширину и высоту `100` для компонента,
    /// который для ширины `100` и высоты `200` уже вернул свою ширину `100` и высоту `50`.
    /// Поэтому этот метод более агрессивно переиспользует известные размеры компонента
    /// для ряда предлагаемых размеров.
    ///
    /// - Parameter targetSize: Целевой размер.
    /// - Returns: Известные размеры компонента.
    internal func contentSize(fitting targetSize: CGSize) -> CGSize? {
        guard targetSize.contains(minReuseSize) else {
            return nil
        }

        if self.targetSize.contains(targetSize) {
            return contentSize
        }

        if contentSize.contains(targetSize) {
            return contentSize
        }

        return nil
    }
}
#endif
