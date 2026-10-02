import SwiftUI

extension Image {

    internal nonisolated func iflet<T>(
        _ condition: T?,
        _ content: (Self, _ value: T) -> Self
    ) -> Image {
        if let value = condition {
            content(self, value)
        } else {
            self
        }
    }
}
