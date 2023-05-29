import SwiftUI

extension ShapeValue: Shape {

    public func path(in rect: CGRect) -> Path {
        let path = path(size: rect.size)

        return Path(path).offsetBy(
            dx: rect.minX,
            dy: rect.minY
        )
    }
}
