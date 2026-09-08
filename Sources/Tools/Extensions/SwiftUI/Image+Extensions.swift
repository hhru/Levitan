import SwiftUI

extension Image {

    @ViewBuilder
    internal nonisolated func iflet<T>(
        _ condition: T?,
        _ apply: (inout Image, T) -> Void
    ) -> Image {
        var result = self

        if let value = condition {
            apply(&result, value)
        }
        return result
    }
}
