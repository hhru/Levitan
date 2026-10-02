import Foundation

public protocol DecorableByForegroundStyle {

    func foregroundStyle(
        _ primaryColor: ColorValue,
        _ secondaryColor: ColorValue?,
        _ tertiaryColor: ColorValue?
    ) -> Self
}
