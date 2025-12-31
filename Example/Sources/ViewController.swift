import UIKit
import SwiftUI
import Levitan

class ViewController: UIViewController {

    let flowView = VerticalFlow.UIView()

    var flow = VerticalFlow.empty {
        didSet { flowView.update(with: flow, context: context) }
    }

    var context: ComponentContext {
        ComponentContext
            .default
            .componentViewController(self)
            .componentContainerSize(view.bounds.size)
    }

    private func setupFlowView() {
        view.addSubview(flowView)

        flowView.contentInsetAdjustmentBehavior = .always
        flowView.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            flowView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            flowView.topAnchor.constraint(equalTo: view.topAnchor),
            flowView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            flowView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    private func testUpdateWithoutChanges() {
        flow = VerticalFlow {
            FlowSection(
                identifier: 0,
                items: (0..<1).map { index in
                    Foo(title: "Cell: 0 - \(index)", color: .lightGray)
                        .flowItem(identifier: "0-\(index)")
                }
            )
            .header(Foo(title: "Header", color: UIColor.blue.withAlphaComponent(0.75)).flowHeader())
            .footer(Foo(title: "Footer", color: UIColor.green.withAlphaComponent(0.75)).flowFooter())
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.flow = VerticalFlow {
                FlowSection(
                    identifier: 0,
                    items: (0..<1).map { index in
                        Foo(title: "Cell: 0 - \(index)", color: .lightGray)
                            .flowItem(identifier: "0-\(index)")
                    }
                )
                .header(Foo(title: "Header", color: UIColor.blue.withAlphaComponent(0.75)).flowHeader())
                .footer(Foo(title: "Footer", color: UIColor.green.withAlphaComponent(0.75)).flowFooter())
            }
        }
    }

    private func testSectionReloading() {
        flow = VerticalFlow {
            FlowSection(
                identifier: 0,
                items: (0..<1).map { index in
                    Foo(title: "Cell: 0 - \(index)", color: .lightGray)
                        .flowItem(identifier: "0-\(index)")
                }
            )
            .header(Foo(title: "Header", color: UIColor.blue.withAlphaComponent(0.75)).flowHeader())
//            .footer(Foo(title: "Footer", color: UIColor.green.withAlphaComponent(0.75)).flowFooter())
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.flow = VerticalFlow {
                FlowSection(
                    identifier: 0,
                    items: (0..<1).map { index in
                        Foo(title: "Cell: 0 - \(index)", color: .lightGray)
                            .flowItem(identifier: "0-\(index)")
                    }
                )
                .header(Foo(title: "Header \n NEW", color: UIColor.blue.withAlphaComponent(0.75)).flowHeader())
//                .footer(Foo(title: "Footer \n NEW", color: UIColor.green.withAlphaComponent(0.75)).flowFooter())
            }
        }
    }

    private func testSectionInserting() {
        flow = VerticalFlow(sections: [])

        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.flow = VerticalFlow {
                FlowSection(
                    identifier: 1,
                    items: (0..<1).map { index in
                        Foo(title: "Cell: 1 - \(index)", color: .lightGray)
                            .flowItem(identifier: "1-\(index)")
                    }
                )
                .header(Foo(title: "Header", color: UIColor.blue.withAlphaComponent(0.75)).flowHeader())
            }
        }
    }

    private func testSectionDeleting() {
        flow = VerticalFlow {
            FlowSection(
                identifier: 0,
                items: (0..<2).map { index in
                    Foo(title: "Cell: 0 - \(index)", color: .lightGray)
                        .flowItem(identifier: "0-\(index)")
                }
            )

            FlowSection(
                identifier: 1,
                items: (0..<1).map { index in
                    Foo(title: "Cell: 1 - \(index)", color: .lightGray)
                        .flowItem(identifier: "1-\(index)")
                }
            )
            .header(Foo(title: "Header", color: UIColor.blue.withAlphaComponent(0.75)).flowHeader())
            .footer(Foo(title: "Footer", color: UIColor.green.withAlphaComponent(0.75)).flowFooter())

            FlowSection(
                identifier: 2,
                items: (0..<2).map { index in
                    Foo(title: "Cell: 2 - \(index)", color: .lightGray)
                        .flowItem(identifier: "2-\(index)")
                }
            )
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.flow = VerticalFlow {
                FlowSection(
                    identifier: 0,
                    items: (0..<2).map { index in
                        Foo(title: "Cell: 0 - \(index)", color: .lightGray)
                            .flowItem(identifier: "0-\(index)")
                    }
                )

                FlowSection(
                    identifier: 2,
                    items: (0..<2).map { index in
                        Foo(title: "Cell: 2 - \(index)", color: .lightGray)
                            .flowItem(identifier: "2-\(index)")
                    }
                )
            }
        }
    }

    private func testSectionMoving() {
        flow = VerticalFlow {
            FlowSection(
                identifier: 0,
                items: (0..<1).map { index in
                    Foo(title: "Cell: 0 - \(index)", color: .lightGray)
                        .flowItem(identifier: "0-\(index)")
                }
            )
            .header(Foo(title: "Header", color: UIColor.blue.withAlphaComponent(0.75)).flowHeader())
            .footer(Foo(title: "Footer", color: UIColor.green.withAlphaComponent(0.75)).flowFooter())

            FlowSection(
                identifier: 1,
                items: (0..<2).map { index in
                    Foo(title: "Cell: 1 - \(index)", color: .lightGray)
                        .flowItem(identifier: "1-\(index)")
                }
            )

            FlowSection(
                identifier: 2,
                items: (0..<2).map { index in
                    Foo(title: "Cell: 2 - \(index)", color: .lightGray)
                        .flowItem(identifier: "2-\(index)")
                }
            )
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.flow = VerticalFlow {
                FlowSection(
                    identifier: 1,
                    items: (0..<2).map { index in
                        Foo(title: "Cell: 1 - \(index)", color: .lightGray)
                            .flowItem(identifier: "1-\(index)")
                    }
                )

                FlowSection(
                    identifier: 2,
                    items: (0..<2).map { index in
                        Foo(title: "Cell: 2 - \(index)", color: .lightGray)
                            .flowItem(identifier: "2-\(index)")
                    }
                )

                FlowSection(
                    identifier: 0,
                    items: (0..<1).map { index in
                        Foo(title: "Cell: 0 - \(index)", color: .lightGray)
                            .flowItem(identifier: "0-\(index)")
                    }
                )
                .header(Foo(title: "Header", color: UIColor.blue.withAlphaComponent(0.75)).flowHeader())
                .footer(Foo(title: "Footer", color: UIColor.green.withAlphaComponent(0.75)).flowFooter())
            }
        }
    }

    private func testItemReloading() {
        flow = VerticalFlow {
            FlowSection(identifier: 0) {
                Foo(title: "Cell: 0 - 1", color: .lightGray)
                    .flowItem(identifier: "0-1")
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.flow = VerticalFlow {
                FlowSection(identifier: 0) {
                    Foo(title: "Cell: 0 - 1\n NEW", color: .lightGray)
                        .flowItem(identifier: "0-1")
                }
            }
        }
    }

    private func testItemInserting() {
        flow = VerticalFlow {
            FlowSection(identifier: 0) {
                Foo(title: "Cell: 0 - 0", color: .lightGray)
                    .flowItem(identifier: "0-0")

                Foo(title: "Cell: 0 - 2", color: .lightGray)
                    .flowItem(identifier: "0-2")
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.flow = VerticalFlow {
                FlowSection(identifier: 0) {
                    Foo(title: "Cell: 0 - 0", color: .lightGray)
                        .flowItem(identifier: "0-0")

                    Foo(title: "Cell: 0 - 1", color: .lightGray)
                        .flowItem(identifier: "0-1")

                    Foo(title: "Cell: 0 - 2", color: .lightGray)
                        .flowItem(identifier: "0-2")
                }
            }
        }
    }

    private func testItemDeleting() {
        flow = VerticalFlow {
            FlowSection(identifier: 0) {
                Foo(title: "Cell: 0 - 0", color: .lightGray)
                    .flowItem(identifier: "0-0")

                Foo(title: "Cell: 0 - 1", color: .lightGray)
                    .flowItem(identifier: "0-1")

                Foo(title: "Cell: 0 - 2", color: .lightGray)
                    .flowItem(identifier: "0-2")
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.flow = VerticalFlow {
                FlowSection(identifier: 0) {
                    Foo(title: "Cell: 0 - 0", color: .lightGray)
                        .flowItem(identifier: "0-0")

                    Foo(title: "Cell: 0 - 2", color: .lightGray)
                        .flowItem(identifier: "0-2")
                }
            }
        }
    }

    private func testItemMoving() {
        flow = VerticalFlow {
            FlowSection(identifier: 0) {
                Foo(title: "Cell: 0 - 0", color: .lightGray)
                    .flowItem(identifier: "0-0")

                Foo(title: "Cell: 0 - 1", color: .lightGray)
                    .flowItem(identifier: "0-1")

                Foo(title: "Cell: 0 - 2", color: .lightGray)
                    .flowItem(identifier: "0-2")
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.flow = VerticalFlow {
                FlowSection(identifier: 0) {
                    Foo(title: "Cell: 0 - 1", color: .lightGray)
                        .flowItem(identifier: "0-1")

                    Foo(title: "Cell: 0 - 2", color: .lightGray)
                        .flowItem(identifier: "0-2")

                    Foo(title: "Cell: 0 - 0", color: .lightGray)
                        .flowItem(identifier: "0-0")
                }
            }
        }
    }

    private func testSwiftUIItemReloading() {
        flow = VerticalFlow {
            FlowSection(identifier: 0) {
                Bar(title: "Cell: 0 - 0\n NEW \n NEW", color: .gray)
                    .flowItem(identifier: "0-0")
            }
        }

//        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
//            self.flow = VerticalFlow {
//                FlowSection(identifier: 0) {
//                    Bar(title: "Cell: 0 - 0 NEW \n NEW \n NEW", color: .gray)
//                        .flowItem(identifier: "0-0")
//                }
//            }
//        }
    }

    private func testTextWithFrameReloading() {
        flow = VerticalFlow {
            FlowSection(identifier: 0) {
                Text("Cell: 0 - 0")
                    .frame(width: .fill)
                    .flowItem(identifier: "0-0")
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.flow = VerticalFlow {
                FlowSection(identifier: 0) {
                    Text("Cell: 0 - 0 NEW \n NEW")
                        .frame(width: .fill)
                        .flowItem(identifier: "0-0")
                }
            }
        }
    }

    private func testInsetsChanging() {
        flow = VerticalFlow {
            FlowSection(identifier: 1) {
                Foo(title: "Cell: 0 - 0", color: .lightGray)
                    .flowItem(identifier: "1-0")

                Foo(title: "Cell: 0 - 2", color: .lightGray)
                    .flowItem(identifier: "1-2")
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.flow = VerticalFlow {
                FlowSection(identifier: 1) {
                    Foo(title: "Cell: 0 - 0", color: .lightGray)
                        .flowItem(identifier: "1-0")

                    Foo(title: "Cell: 0 - 2", color: .lightGray)
                        .flowItem(identifier: "1-2")
                }
            }
            .insets(all: 16.0)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.tokens.themeScheme(nil)

        setupFlowView()
        testSwiftUIItemReloading()
    }
}
