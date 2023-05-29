import Foundation

internal enum MethodSwizzler {

    internal static func swizzle(
        class: AnyClass,
        originalSelector: Selector,
        swizzledSelector: Selector
    ) {
        guard let originalMethod = class_getInstanceMethod(`class`, originalSelector) else {
            return
        }

        guard let swizzledMethod = class_getInstanceMethod(`class`, swizzledSelector) else {
            return
        }

        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
}
