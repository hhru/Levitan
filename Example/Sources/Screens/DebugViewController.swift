import UIKit
import SwiftUI
import Levitan

// swiftlint:disable all

struct Bar: Component {

    let title: String
    let color: Color

    var body: some SwiftUI.View {
        Text(title)
            .font(.title)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(color)
    }

    func sizing(fitting size: CGSize, context: ComponentContext) -> ComponentSizing {
        ComponentSizing(
            width: .fill,
            height: .hug
        )
    }
}

struct Foo: FallbackComponent {

    typealias UIView = FooView

    let title: String
    let color: UIColor
}

final class FooView: UIView {

    private let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        tokens.stroke = .inside(width: 1.0, color: 0x000000FF)

        setupLabel()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLabel() {
        addSubview(label)

        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]

        NSLayoutConstraint.activate(constraints)
    }
}

extension FooView: FallbackComponentView {

    static func sizing(
        for content: Foo,
        fitting size: CGSize,
        context: ComponentContext
    ) -> ComponentSizing {
        ComponentSizing(
            width: .fill,
            height: .hug
        )
    }

    func update(with content: Foo, context: ComponentContext) {
        label.attributedText = NSAttributedString(
            string: content.title,
            attributes: [.font: UIFont.preferredFont(forTextStyle: .title1)]
        )

        backgroundColor = content.color
    }
}


extension Token where Value == ThemeTypographies {

    subscript(dynamicMember relativePath: KeyPath<Value, TypographyToken> & Sendable) -> TypographyToken {
        Token<TypographyValue>(trait: relativePath) { theme in
            resolve(for: theme)[keyPath: relativePath]
                .resolve(for: theme)
                .fontScale(FontScaleValue(textStyle: .title2))
        }
    }
}

class DebugViewController: UIViewController {

    let flowView = VFlow.UIView()

    var flow = VFlow.empty {
        didSet { flowView.update(with: flow, context: context) }
    }

    var context: ComponentContext {
        ComponentContext
            .default
            .componentViewController(self)
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
        flow = VFlow {
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
            self.flow = VFlow {
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
        flow = VFlow {
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
            self.flow = VFlow {
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
        flow = VFlow(sections: [])

        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.flow = VFlow {
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
        flow = VFlow {
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
            self.flow = VFlow {
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
        flow = VFlow {
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
            self.flow = VFlow {
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
        flow = VFlow {
            FlowSection(identifier: 0) {
                Foo(title: "Cell: 0 - 1", color: .lightGray)
                    .flowItem(identifier: "0-1")
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.flow = VFlow {
                FlowSection(identifier: 0) {
                    Foo(title: "Cell: 0 - 1\n NEW", color: .lightGray)
                        .flowItem(identifier: "0-1")
                }
            }
        }
    }

    private func testItemInserting() {
        flow = VFlow {
            FlowSection(identifier: 0) {
                Foo(title: "Cell: 0 - 0", color: .lightGray)
                    .flowItem(identifier: "0-0")

                Foo(title: "Cell: 0 - 2", color: .lightGray)
                    .flowItem(identifier: "0-2")
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.flow = VFlow {
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
        flow = VFlow {
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
            self.flow = VFlow {
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
        flow = VFlow {
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
            self.flow = VFlow {
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
        flow = VFlow {
            FlowSection(identifier: 0) {
                Bar(title: "Cell: 0 - 0\n NEW \n NEW", color: .gray)
                    .flowItem(identifier: "0-0")
            }
        }

//        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
//            self.flow = VFlow {
//                FlowSection(identifier: 0) {
//                    Bar(title: "Cell: 0 - 0 NEW \n NEW \n NEW", color: .gray)
//                        .flowItem(identifier: "0-0")
//                }
//            }
//        }
    }

    private func testTextWithFrameReloading() {
        flow = VFlow {
            FlowSection(identifier: 0) {
                Text("Cell: 0 - 0")
                    .frame(width: .fill)
                    .flowItem(identifier: "0-0")
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.flow = VFlow {
                FlowSection(identifier: 0) {
                    Text("Cell: 0 - 0 NEW \n NEW")
                        .frame(width: .fill)
                        .flowItem(identifier: "0-0")
                }
            }
        }
    }

    private func testInsetsChanging() {
        flow = VFlow {
            FlowSection(identifier: 1) {
                Foo(title: "Cell: 0 - 0", color: .lightGray)
                    .flowItem(identifier: "1-0")

                Foo(title: "Cell: 0 - 2", color: .lightGray)
                    .flowItem(identifier: "1-2")
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.flow = VFlow {
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

        view.tokens.backgroundColor = Colors.background.default

        setupFlowView()
        testSectionReloading()
    }
}

// swiftlint:enable all
