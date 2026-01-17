import UIKit
import SwiftUI
import Levitan

class DebugViewController: UIViewController {

    private var context = ComponentContext.default
    private let contentView = VFlow.UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.tokens.backgroundColor = Colors.background.default

        context = context
            .componentViewController(self)
            .fallbackComponentCache(FallbackComponentCache())
            .textCache(TextCache())

        setupNavigationBar()
        setupContentView()

        updateContentView()
    }
}

extension DebugViewController {

    private func setupNavigationBar() {
        navigationItem.title = "Debug"
    }

    private func setupContentView() {
        view.addSubview(contentView)

        contentView.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]

        NSLayoutConstraint.activate(constraints)
    }

    private func updateContentView() {
        let content = VFlow {
            performanceItem

            testsItem(title: "Sections tests", tests: Test.sections)
            testsItem(title: "Items tests", tests: Test.items)
            testsItem(title: "Other tests", tests: Test.other)
        }
        .contentMarginsAdjustmentBehavior(.always)
        .scrollAlwaysBounces()

        contentView.update(
            with: content,
            context: context
        )
    }
}

extension DebugViewController {

    var performanceItem: any FlowItem {
        Text("⏱️  Measure performance")
            .typography(Typographies.label1)
            .foregroundColor(Colors.text.primary)
            .frame(width: .fill, alignment: .leading)
            .onTap { [weak self] in
                self?.onPerformanceTap()
            }
            .card()
            .padding(top: 16.0, leading: 16.0, trailing: 16.0)
            .flowItem(id: #function)
    }

    func testsItem(title: String, tests: [Test]) -> any FlowItem {
        VFlow(itemsData: Array(tests.enumerated()), itemsID: \.element.title) { index, test in
            Text(test.title)
                .typography(Typographies.label1)
                .foregroundColor(Colors.text.primary)
                .padding(top: index > .zero ? 12.0 : .zero)
                .padding(bottom: index < tests.count - 1 ? 12.0 : .zero)
                .frame(width: .fill, alignment: .leading)
                .onTap { [weak self] in
                    self?.onTestTap(test: test)
                }
        }
        .card(header: CardHeader(title: title))
        .padding(top: 24.0, leading: 16.0, trailing: 16.0)
        .flowItem(id: title)
    }
}

extension DebugViewController {

    func onPerformanceTap() {
        let navigationController = UINavigationController(
            rootViewController: PerformanceViewController()
        )

        navigationController.modalPresentationStyle = .fullScreen
        navigationController.modalTransitionStyle = .coverVertical

        present(navigationController, animated: true)
    }

    func onTestTap(test: Test) {
        navigationController?.pushViewController(
            TestViewController(test: test),
            animated: true
        )
    }
}
