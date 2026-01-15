import Levitan
import SwiftUI
import UIKit

struct TestElement {

    let title: String
    let description: String?

    let textColor: ColorToken
    let backgroundColor: ColorToken
}

extension TestElement: FallbackComponent {

    typealias UIView = TestElementView
}

extension TestElement {

    static func item(section: Int, row: Int, description: String? = nil) -> Self {
        Self(
            title: "Item \(section) - \(row)",
            description: description,
            textColor: row.isMultiple(of: 2)
                ? Colors.debug.primaryItemText
                : Colors.debug.secondaryItemText,
            backgroundColor: row.isMultiple(of: 2)
                ? Colors.debug.primaryItemBackground
                : Colors.debug.secondaryItemBackground
        )
    }

    static func header(section: Int, description: String? = nil) -> Self {
        Self(
            title: "Header \(section)",
            description: description,
            textColor: Colors.debug.headerText,
            backgroundColor: Colors.debug.headerBackground
        )
    }

    static func footer(section: Int, description: String? = nil) -> Self {
        Self(
            title: "Footer \(section)",
            description: description,
            textColor: Colors.debug.footerText,
            backgroundColor: Colors.debug.footerBackground
        )
    }
}

#Preview {
    VStack(spacing: .zero) {
        TestElement.header(section: 0, description: nil)
        TestElement.item(section: 0, row: 0, description: nil)
        TestElement.item(section: 0, row: 1, description: nil)
        TestElement.item(section: 0, row: 2, description: nil)
        TestElement.footer(section: 0, description: nil)
    }
}
