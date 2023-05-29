import SwiftUI

extension View {

    @ViewBuilder
    internal func `if`<Content: View>(
        _ condition: Bool,
        @ViewBuilder transform: (Self) -> Content
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }

    @ViewBuilder
    internal func iflet<Content: View, T>(
        _ condition: T?,
        @ViewBuilder _ content: (Self, _ value: T) -> Content
    ) -> some View {
        if let value = condition {
            content(self, value)
        } else {
            self
        }
    }
}
