import SwiftUI

struct CellDivider: Equatable, Sendable { }

extension CellDivider: View {

    var body: some View {
        Colors
            .stroke
            .frame(height: 1.0)
            .frame(maxWidth: .infinity)
    }
}

#Preview {
    CellDivider()
}
