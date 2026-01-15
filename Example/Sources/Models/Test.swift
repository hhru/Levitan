import Foundation
import Levitan

struct Test {

    let title: String

    let initialContent: VFlow
    let finalContent: VFlow
}

extension Test {

    static let sections = [
        sectionReloading,
        sectionInsertion,
        sectionDeletion,
        sectionMoving,
        sectionIDChange
    ]

    static let sectionReloading = Self(
        title: "☑️  Section reloading",
        initialContent: VFlow {
            VFlowSection(id: 0, itemsData: 0..<1) { row in
                TestElement.item(section: 0, row: row)
            }

            VFlowSection(id: 1, itemsData: 0..<3) { row in
                TestElement.item(section: 1, row: row)
            }
            .header(TestElement.header(section: 1))
            .footer(TestElement.footer(section: 1))

            VFlowSection(id: 2, itemsData: 0..<1) { row in
                TestElement.item(section: 2, row: row)
            }
        },
        finalContent: VFlow {
            VFlowSection(id: 0, itemsData: 0..<1) { row in
                TestElement.item(section: 0, row: row)
            }

            VFlowSection(id: 1, itemsData: 0..<3) { row in
                TestElement.item(section: 1, row: row)
            }
            .header(TestElement.header(section: 1, description: "Reloaded"))
            .footer(TestElement.footer(section: 1, description: "Reloaded"))

            VFlowSection(id: 2, itemsData: 0..<1) { row in
                TestElement.item(section: 2, row: row)
            }
        }
    )

    static let sectionInsertion = Self(
        title: "☑️  Section insertion",
        initialContent: VFlow {
            VFlowSection(id: 0, itemsData: 0..<1) { row in
                TestElement.item(section: 0, row: row)
            }

            VFlowSection(id: 2, itemsData: 0..<1) { row in
                TestElement.item(section: 2, row: row)
            }
        },
        finalContent: VFlow {
            VFlowSection(id: 0, itemsData: 0..<1) { row in
                TestElement.item(section: 0, row: row)
            }

            VFlowSection(id: 1, itemsData: 0..<3) { row in
                TestElement.item(section: 1, row: row)
            }
            .header(TestElement.header(section: 1))
            .footer(TestElement.footer(section: 1))

            VFlowSection(id: 2, itemsData: 0..<1) { row in
                TestElement.item(section: 2, row: row)
            }
        }
    )

    static let sectionDeletion = Self(
        title: "☑️  Section deletion",
        initialContent: VFlow {
            VFlowSection(id: 0, itemsData: 0..<3) { row in
                TestElement.item(section: 0, row: row)
            }

            VFlowSection(id: 1, itemsData: 0..<1) { row in
                TestElement.item(section: 1, row: row)
            }
            .header(TestElement.header(section: 1))
            .footer(TestElement.footer(section: 1))

            VFlowSection(id: 2, itemsData: 0..<3) { row in
                TestElement.item(section: 2, row: row)
            }
        },
        finalContent: VFlow {
            VFlowSection(id: 0, itemsData: 0..<3) { row in
                TestElement.item(section: 0, row: row)
            }

            VFlowSection(id: 2, itemsData: 0..<3) { row in
                TestElement.item(section: 2, row: row)
            }
        }
    )

    static let sectionMoving = Self(
        title: "☑️  Section moving",
        initialContent: VFlow {
            VFlowSection(id: 0, itemsData: 0..<1) { row in
                TestElement.item(section: 0, row: row)
            }
            .header(TestElement.header(section: 0))
            .footer(TestElement.footer(section: 0))

            VFlowSection(id: 1, itemsData: 0..<3) { row in
                TestElement.item(section: 1, row: row)
            }

            VFlowSection(id: 2, itemsData: 0..<3) { row in
                TestElement.item(section: 2, row: row)
            }
        },
        finalContent: VFlow {
            VFlowSection(id: 1, itemsData: 0..<3) { row in
                TestElement.item(section: 1, row: row)
            }

            VFlowSection(id: 2, itemsData: 0..<3) { row in
                TestElement.item(section: 2, row: row)
            }

            VFlowSection(id: 0, itemsData: 0..<1) { row in
                TestElement.item(section: 0, row: row)
            }
            .header(TestElement.header(section: 0))
            .footer(TestElement.footer(section: 0))
        }
    )

    static let sectionIDChange = Self(
        title: "☑️  Section ID change",
        initialContent: VFlow {
            VFlowSection(id: "Foo") {
                TestElement
                    .item(section: 0, row: 0)
                    .flowItem(id: 0)

                TestElement
                    .item(section: 0, row: 1)
                    .flowItem(id: 1)

                TestElement
                    .item(section: 0, row: 2)
                    .flowItem(id: 2)
            }
            .header(TestElement.header(section: 0))
            .footer(TestElement.footer(section: 0))
        },
        finalContent: VFlow {
            VFlowSection(id: "Bar") {
                TestElement
                    .item(section: 0, row: 0)
                    .flowItem(id: 0)

                TestElement
                    .item(section: 0, row: 1)
                    .flowItem(id: 1)

                TestElement
                    .item(section: 0, row: 2)
                    .flowItem(id: 2)
            }
            .header(TestElement.header(section: 0))
            .footer(TestElement.footer(section: 0))
        }
    )
}

extension Test {

    static let items = [
        itemReloading,
        itemInsertion,
        itemDeletion,
        itemMoving
    ]

    static let itemReloading = Self(
        title: "☑️  Item reloading",
        initialContent: VFlow {
            VFlowSection(id: 0) {
                TestElement
                    .item(section: 0, row: 0)
                    .flowItem(id: 0)

                TestElement
                    .item(section: 0, row: 1)
                    .flowItem(id: 1)

                TestElement
                    .item(section: 0, row: 2)
                    .flowItem(id: 2)
            }
            .header(TestElement.header(section: 0))
            .footer(TestElement.footer(section: 0))
        },
        finalContent: VFlow {
            VFlowSection(id: 0) {
                TestElement
                    .item(section: 0, row: 0)
                    .flowItem(id: 0)

                TestElement
                    .item(section: 0, row: 1, description: "Reloaded")
                    .flowItem(id: 1)

                TestElement
                    .item(section: 0, row: 2)
                    .flowItem(id: 2)
            }
            .header(TestElement.header(section: 0))
            .footer(TestElement.footer(section: 0))
        }
    )

    static let itemInsertion = Self(
        title: "☑️  Item insertion",
        initialContent: VFlow {
            VFlowSection(id: 0) {
                TestElement
                    .item(section: 0, row: 0)
                    .flowItem(id: 0)

                TestElement
                    .item(section: 0, row: 2)
                    .flowItem(id: 2)
            }
            .header(TestElement.header(section: 0))
            .footer(TestElement.footer(section: 0))
        },
        finalContent: VFlow {
            VFlowSection(id: 0) {
                TestElement
                    .item(section: 0, row: 0)
                    .flowItem(id: 0)

                TestElement
                    .item(section: 0, row: 1)
                    .flowItem(id: 1)

                TestElement
                    .item(section: 0, row: 2)
                    .flowItem(id: 2)
            }
            .header(TestElement.header(section: 0))
            .footer(TestElement.footer(section: 0))
        }
    )

    static let itemDeletion = Self(
        title: "☑️  Item deletion",
        initialContent: VFlow {
            VFlowSection(id: 0) {
                TestElement
                    .item(section: 0, row: 0)
                    .flowItem(id: 0)

                TestElement
                    .item(section: 0, row: 1)
                    .flowItem(id: 1)

                TestElement
                    .item(section: 0, row: 2)
                    .flowItem(id: 2)
            }
            .header(TestElement.header(section: 0))
            .footer(TestElement.footer(section: 0))
        },
        finalContent: VFlow {
            VFlowSection(id: 0) {
                TestElement
                    .item(section: 0, row: 0)
                    .flowItem(id: 0)

                TestElement
                    .item(section: 0, row: 2)
                    .flowItem(id: 2)
            }
            .header(TestElement.header(section: 0))
            .footer(TestElement.footer(section: 0))
        }
    )

    static let itemMoving = Self(
        title: "☑️  Item moving",
        initialContent: VFlow {
            VFlowSection(id: 0) {
                TestElement
                    .item(section: 0, row: 0)
                    .flowItem(id: 0)

                TestElement
                    .item(section: 0, row: 1)
                    .flowItem(id: 1)

                TestElement
                    .item(section: 0, row: 2)
                    .flowItem(id: 2)
            }
            .header(TestElement.header(section: 0))
            .footer(TestElement.footer(section: 0))
        },
        finalContent: VFlow {
            VFlowSection(id: 0) {
                TestElement
                    .item(section: 0, row: 1)
                    .flowItem(id: 1)

                TestElement
                    .item(section: 0, row: 2)
                    .flowItem(id: 2)

                TestElement
                    .item(section: 0, row: 0)
                    .flowItem(id: 0)
            }
            .header(TestElement.header(section: 0))
            .footer(TestElement.footer(section: 0))
        }
    )
}

extension Test {

    static let other = [
        updateWithoutChanges,
        insetsChange
    ]

    static let updateWithoutChanges = Self(
        title: "☑️  Update without changes",
        initialContent: VFlow {
            VFlowSection(id: 0, itemsData: 0..<3) { row in
                TestElement.item(section: 0, row: row)
            }
            .header(TestElement.header(section: 0))
            .footer(TestElement.footer(section: 0))
        },
        finalContent: VFlow {
            VFlowSection(id: 0, itemsData: 0..<3) { row in
                TestElement.item(section: 0, row: row)
            }
            .header(TestElement.header(section: 0))
            .footer(TestElement.footer(section: 0))
        }
    )

    static let insetsChange = Self(
        title: "☑️  Insets сhanging",
        initialContent: VFlow {
            VFlowSection(id: 0, itemsData: 0..<3) { row in
                TestElement.item(section: 0, row: row)
            }
            .header(TestElement.header(section: 0))
            .footer(TestElement.footer(section: 0))
        },
        finalContent: VFlow {
            VFlowSection(id: 0, itemsData: 0..<3) { row in
                TestElement.item(section: 0, row: row)
            }
            .header(TestElement.header(section: 0))
            .footer(TestElement.footer(section: 0))
        }
        .insets(16.0)
    )
}
