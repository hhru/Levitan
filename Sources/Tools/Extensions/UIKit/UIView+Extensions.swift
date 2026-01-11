#if canImport(UIKit)
import UIKit

extension UIView {

    /// Получает размеры с заданной шириной и высотой.
    ///
    /// Собственные размеры UI-представления будут проигнорированы
    /// в зависимости от значений параметров `isWidthForced` и `isHeightForced`.
    ///
    /// - Parameters:
    ///   - width: Ширина.
    ///   - isWidthForced: Флаг, игнорирующий собственную ширину.
    ///   - height: Высота.
    ///   - isHeightForced: Флаг, игнорирующий собственную высоту.
    /// - Returns: Соответствующие размеры.
    internal func sizeWithFixedWidthAndFixedHeight(
        width: CGFloat,
        isWidthForced: Bool = true,
        height: CGFloat,
        isHeightForced: Bool = true
    ) -> CGSize {
        let targetSize = CGSize(width: width, height: height)

        if isWidthForced, isHeightForced {
            return targetSize
        }

        let size = systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .almostRequired,
            verticalFittingPriority: .almostRequired
        )

        return CGSize(
            width: isWidthForced ? width : size.width,
            height: isHeightForced ? height : size.height
        )
    }

    /// Получает размеры с заданной шириной и c собственной высотой.
    ///
    /// Собственная ширина UI-представления будет проигнорирована
    /// в зависимости от значения параметра `isWidthForced`.
    ///
    /// Если высота контейнера в параметре `containerHeight` равна `nil` или `zero`,
    /// то будет получена минимальная высота UI-представления.
    ///
    /// Итоговая высота будет ограничена максимальной высотой в параметре `maxHeight`,
    /// если она больше минимальной высоты UI-представления.
    ///
    /// Если UI-представление не имеет собственной высоты, то итоговая высота будет равна
    /// либо высоте контейнера, либо минимальной высоте.
    ///
    /// - Parameters:
    ///   - width: Ширина.
    ///   - isWidthForced: Флаг, игнорирующий собственную ширину.
    ///   - containerHeight: Высота контейнера.
    ///   - maxHeight: Максимальная высоты.
    /// - Returns: Соответствующие размеры.
    internal func sizeWithFixedWidthAndHuggingHeight(
        width: CGFloat,
        isWidthForced: Bool = true,
        containerHeight: CGFloat,
        maxHeight: CGFloat?
    ) -> CGSize {
        let targetHeight = containerHeight.nonZero.map { containerHeight in
            containerHeight.isInfinite
                ? UIView.layoutFittingExpandedSize.height
                : containerHeight
        } ?? UIView.layoutFittingCompressedSize.height

        let targetSize = CGSize(width: width, height: targetHeight)

        var size = systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .almostRequired,
            verticalFittingPriority: .fittingSizeLevel
        )

        if let maxHeight = maxHeight?.nonZero, maxHeight < size.height {
            // Если собственный размер превышает максимальный размер,
            // то уточняем размер с близким к required приоритетом.
            let targetSize = CGSize(width: width, height: maxHeight)

            size = systemLayoutSizeFitting(
                targetSize,
                withHorizontalFittingPriority: .almostRequired,
                verticalFittingPriority: .almostRequired
            )
        }

        return CGSize(
            width: isWidthForced ? width : size.width,
            height: size.height
        )
    }

    /// Получает размеры с заданной шириной и c высотой, заполняющей контейнер.
    ///
    /// Собственная ширина UI-представления будет проигнорирована
    /// в зависимости от значения параметра `isWidthForced`.
    ///
    /// Если высота контейнера в параметре `containerHeight` равна `nil` или `zero`,
    /// то будет получена минимальная высота UI-представления,
    /// иначе итоговый размер будет иметь высоту контейнера,
    /// если она больше минимальной и меньше максимальной высоты UI-представления.
    ///
    /// - Parameters:
    ///   - width: Ширина.
    ///   - isWidthForced: Флаг, игнорирующий собственную ширину.
    ///   - containerHeight: Высота контейнера.
    /// - Returns: Соответствующие размеры.
    internal func sizeWithFixedWidthAndFillingHeight(
        width: CGFloat,
        isWidthForced: Bool = true,
        containerHeight: CGFloat
    ) -> CGSize {
        let targetHeight = containerHeight.nonZero.map { containerHeight in
            containerHeight.isInfinite
                ? UIView.layoutFittingExpandedSize.height
                : containerHeight
        } ?? UIView.layoutFittingCompressedSize.height

        let targetSize = CGSize(width: width, height: targetHeight)

        let size = systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .almostRequired,
            verticalFittingPriority: containerHeight.isNormal
                ? .almostRequired
                : .fittingSizeLevel
        )

        return CGSize(
            width: isWidthForced ? width : size.width,
            height: size.height
        )
    }

    /// Получает размеры с собственной шириной и c заданной высотой.
    ///
    /// Если ширина контейнера в параметре `containerWidth` равна `nil` или `zero`,
    /// то будет получена минимальная ширина UI-представления.
    ///
    /// Итоговая ширина будет ограничена максимальной шириной в параметре `maxWidth`,
    /// если она больше минимальной ширины UI-представления.
    ///
    /// Если UI-представление не имеет собственной ширины, то итоговая ширина будет равна
    /// либо ширине контейнера, либо минимальной ширине.
    ///
    /// Собственная высота UI-представления будет проигнорирована
    /// в зависимости от значения параметра `isHeightForced`.
    ///
    /// - Parameters:
    ///   - containerWidth: Ширина контейнера.
    ///   - maxWidth: Максимальная ширина.
    ///   - height: Высота.
    ///   - isHeightForced: Флаг, игнорирующий собственную высоту.
    /// - Returns: Соответствующие размеры.
    internal func sizeWithHuggingWidthAndFixedHeight(
        containerWidth: CGFloat,
        maxWidth: CGFloat?,
        height: CGFloat,
        isHeightForced: Bool = true
    ) -> CGSize {
        let targetWidth = containerWidth.nonZero.map { containerWidth in
            containerWidth.isInfinite
                ? UIView.layoutFittingExpandedSize.width
                : containerWidth
        } ?? UIView.layoutFittingCompressedSize.width

        let targetSize = CGSize(width: targetWidth, height: height)

        var size = systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .fittingSizeLevel,
            verticalFittingPriority: .almostRequired
        )

        if let maxWidth = maxWidth?.nonZero, maxWidth < size.width {
            // Если собственный размер превышает максимальный размер,
            // то уточняем размер с близким к required приоритетом.
            let targetSize = CGSize(width: maxWidth, height: height)

            size = systemLayoutSizeFitting(
                targetSize,
                withHorizontalFittingPriority: .almostRequired,
                verticalFittingPriority: .almostRequired
            )
        }

        return CGSize(
            width: size.width,
            height: isHeightForced ? height : size.height
        )
    }

    /// Получает размеры с собственными шириной и высотой.
    ///
    /// Если размер контейнера в параметре `containerWidth` и/или `containerHeight`
    /// равен `nil` или `zero` , то будет получен минимальный размер для измерения этого параметра.
    ///
    /// Итоговые размеры будут ограничены максимальными размерами,
    /// которые указаны в параметрах `maxWidth` и `maxHeight`,
    /// если они больше минимального размера UI-представления.
    ///
    /// Если UI-представление не имеет собственного размера в определенном измерении,
    /// то итоговый размер будет равен либо размеру контейнера, либо минимальному размеру
    /// в этом измерении.
    ///
    /// - Parameters:
    ///   - containerWidth: Ширина контейнера.
    ///   - maxWidth: Максимальная ширина.
    ///   - containerHeight: Высота контейнера.
    ///   - maxHeight: Максимальная высота.
    /// - Returns: Соответствующие размеры.
    internal func sizeWithHuggingWidthAndHuggingHeight(
        containerWidth: CGFloat,
        maxWidth: CGFloat?,
        containerHeight: CGFloat,
        maxHeight: CGFloat?
    ) -> CGSize {
        let targetWidth = containerWidth.nonZero.map { containerWidth in
            containerWidth.isInfinite
                ? UIView.layoutFittingExpandedSize.width
                : containerWidth
        } ?? UIView.layoutFittingCompressedSize.width

        let targetHeight = containerHeight.nonZero.map { containerHeight in
            containerHeight.isInfinite
                ? UIView.layoutFittingExpandedSize.height
                : containerHeight
        } ?? UIView.layoutFittingCompressedSize.height

        let targetSize = CGSize(width: targetWidth, height: targetHeight)

        let size = systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .fittingSizeLevel,
            verticalFittingPriority: .fittingSizeLevel
        )

        if let maxWidth = maxWidth?.nonZero, size.width > maxWidth {
            // Если собственный размер превышает максимальный размер,
            // то уточняем размер с близким к required приоритетом.
            return sizeWithFixedWidthAndHuggingHeight(
                width: maxWidth,
                isWidthForced: false,
                containerHeight: containerHeight,
                maxHeight: maxHeight
            )
        }

        if let maxHeight = maxHeight?.nonZero, size.height > maxHeight {
            // Если собственный размер превышает максимальный размер,
            // то уточняем размер с близким к required приоритетом.
            return sizeWithHuggingWidthAndFixedHeight(
                containerWidth: containerWidth,
                maxWidth: maxWidth,
                height: maxHeight,
                isHeightForced: false
            )
        }

        return size
    }

    /// Получает размеры с собственной шириной и c высотой, заполняющей контейнер.
    ///
    /// Если ширина контейнера в параметре `containerWidth` равна `nil` или `zero`,
    /// то будет получена минимальная ширина UI-представления.
    ///
    /// Итоговая ширина будет ограничена максимальной шириной в параметре `maxWidth`,
    /// если она больше минимальной ширины UI-представления.
    ///
    /// Если высота контейнера в параметре `containerHeight` равна `nil` или `zero`,
    /// то будет получена минимальная высота UI-представления,
    /// иначе итоговый размер будет иметь высоту контейнера,
    /// если она больше минимальной и меньше максимальной высоты UI-представления.
    ///
    /// - Parameters:
    ///   - containerWidth: Ширина контейнера.
    ///   - isWidthLimited: Флаг, ограничивающий итоговую ширину контейнером.
    ///   - containerHeight: Высота контейнера.
    /// - Returns: Соответствующие размеры.
    internal func sizeWithHuggingWidthAndFillingHeight(
        containerWidth: CGFloat,
        maxWidth: CGFloat?,
        containerHeight: CGFloat
    ) -> CGSize {
        let targetWidth = containerWidth.nonZero.map { containerWidth in
            containerWidth.isInfinite
                ? UIView.layoutFittingExpandedSize.width
                : containerWidth
        } ?? UIView.layoutFittingCompressedSize.width

        let targetHeight = containerHeight.nonZero.map { containerHeight in
            containerHeight.isInfinite
                ? UIView.layoutFittingExpandedSize.height
                : containerHeight
        } ?? UIView.layoutFittingCompressedSize.height

        let targetSize = CGSize(width: targetWidth, height: targetHeight)

        let size = systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .fittingSizeLevel,
            verticalFittingPriority: containerHeight.isNormal
                ? .almostRequired
                : .fittingSizeLevel
        )

        if let maxWidth = maxWidth?.nonZero, size.width > maxWidth {
            // Если собственный размер превышает максимальный размер,
            // то уточняем размер с близким к required приоритетом.
            return sizeWithFixedWidthAndFillingHeight(
                width: maxWidth,
                isWidthForced: false,
                containerHeight: containerHeight
            )
        }

        return size
    }

    /// Получает размеры с шириной, заполняющей контейнер, и c заданной высотой.
    ///
    /// Если ширина контейнера в параметре `containerWidth` равна `nil` или `zero`,
    /// то будет получена минимальная ширина UI-представления,
    /// иначе итоговый размер будет иметь ширину контейнера,
    /// если она больше минимальной и меньше максимальной ширины UI-представления.
    ///
    /// Собственная высота UI-представления будет проигнорирована
    /// в зависимости от значения параметра `isHeightForced`.
    ///
    /// - Parameters:
    ///   - containerWidth: Высота контейнера.
    ///   - height: Высота.
    ///   - isHeightForced: Флаг, игнорирующий собственную высоту.
    /// - Returns: Соответствующие размеры.
    internal func sizeWithFillingWidthAndFixedHeight(
        containerWidth: CGFloat,
        height: CGFloat,
        isHeightForced: Bool = true
    ) -> CGSize {
        let targetWidth = containerWidth.nonZero.map { containerWidth in
            containerWidth.isInfinite
                ? UIView.layoutFittingExpandedSize.width
                : containerWidth
        } ?? UIView.layoutFittingCompressedSize.width

        let targetSize = CGSize(width: targetWidth, height: height)

        let size = systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: containerWidth.isNormal
                ? .almostRequired
                : .fittingSizeLevel,
            verticalFittingPriority: .almostRequired
        )

        return CGSize(
            width: size.width,
            height: isHeightForced ? height : size.height
        )
    }

    /// Получает размеры с шириной, заполняющей контейнер, и c собственной высотой.
    ///
    /// Если ширина контейнера в параметре `containerWidth` равна `nil` или `zero`,
    /// то будет получена минимальная ширина UI-представления,
    /// иначе итоговый размер будет иметь ширину контейнера,
    /// если она больше минимальной и меньше максимальной ширины UI-представления.
    ///
    /// Если высота контейнера в параметре `containerHeight` равна `nil` или `zero`,
    /// то будет получена минимальная высота UI-представления.
    ///
    /// Итоговая высота будет ограничена максимальной высотой в параметре `maxHeight`,
    /// если она больше минимальной высоты UI-представления.
    ///
    /// - Parameters:
    ///   - containerWidth: Ширина контейнера.
    ///   - containerHeight: Высота контейнера.
    ///   - maxHeight: Максимальная высота.
    /// - Returns: Соответствующие размеры.
    internal func sizeWithFillingWidthAndHuggingHeight(
        containerWidth: CGFloat,
        containerHeight: CGFloat,
        maxHeight: CGFloat?
    ) -> CGSize {
        let targetWidth = containerWidth.nonZero.map { containerWidth in
            containerWidth.isInfinite
                ? UIView.layoutFittingExpandedSize.width
                : containerWidth
        } ?? UIView.layoutFittingCompressedSize.width

        let targetHeight = containerHeight.nonZero.map { containerHeight in
            containerHeight.isInfinite
                ? UIView.layoutFittingExpandedSize.height
                : containerHeight
        } ?? UIView.layoutFittingCompressedSize.height

        let targetSize = CGSize(width: targetWidth, height: targetHeight)

        let size = systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: containerWidth.isNormal
                ? .almostRequired
                : .fittingSizeLevel,
            verticalFittingPriority: .fittingSizeLevel
        )

        if let maxHeight = maxHeight?.nonZero, size.height > maxHeight {
            // Если собственный размер превышает максимальный размер,
            // то уточняем размер с близким к required приоритетом.
            return sizeWithFillingWidthAndFixedHeight(
                containerWidth: containerWidth,
                height: maxHeight,
                isHeightForced: false
            )
        }

        return size
    }

    /// Получает размеры с шириной и высотой, заполняющими контейнер.
    ///
    /// Если размер контейнера в параметре `containerWidth` и/или `containerHeight`
    /// равна `nil` или `zero`, то будет получен минимальный размер для измерения этого параметра,
    /// иначе итоговый размер будет иметь размеры контейнера,
    /// если он больше минимального и меньше максимального размера UI-представления.
    ///
    /// - Parameters:
    ///   - containerWidth: Ширина контейнера.
    ///   - containerHeight: Высота контейнера.
    /// - Returns: Соответствующие размеры.
    internal func sizeWithFillingWidthAndFillingHeight(
        containerWidth: CGFloat,
        containerHeight: CGFloat
    ) -> CGSize {
        let targetWidth = containerWidth.nonZero.map { containerWidth in
            containerWidth.isInfinite
                ? UIView.layoutFittingExpandedSize.width
                : containerWidth
        } ?? UIView.layoutFittingCompressedSize.width

        let targetHeight = containerHeight.nonZero.map { containerHeight in
            containerHeight.isInfinite
                ? UIView.layoutFittingExpandedSize.height
                : containerHeight
        } ?? UIView.layoutFittingCompressedSize.height

        let targetSize = CGSize(width: targetWidth, height: targetHeight)

        return systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: containerWidth.isNormal
                ? .almostRequired
                : .fittingSizeLevel,
            verticalFittingPriority: containerHeight.isNormal
                ? .almostRequired
                : .fittingSizeLevel,
        )
    }
}
#endif
