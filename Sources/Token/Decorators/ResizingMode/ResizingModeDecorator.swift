import Foundation

internal struct ResizingModeDecorator<Value: DecorableByResizingMode>: TokenDecorator {

    internal let resizingMode: ImageResizingMode?

    internal func decorate(_ value: Value, theme: TokenTheme) -> Value {
        value.resizable(resizingMode)
    }
}

extension Token where Value: DecorableByResizingMode {

    public func resizable(_ resizingMode: ImageResizingMode? = .stretch) -> Self {
        decorated(by: ResizingModeDecorator(resizingMode: resizingMode))
    }
}
