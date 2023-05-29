import Foundation

public protocol DecorableByResizingMode {

    func resizable(_ resizingMode: ImageResizingMode?) -> Self
}

extension DecorableByResizingMode {

    public func resizable() -> Self {
        resizable(.stretch)
    }
}
