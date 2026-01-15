import Levitan
import UIKit

final class TestViewController: UIViewController {

    let initialContent: VFlow
    let finalContent: VFlow

    private var context = ComponentContext.default
    private let contentView = VFlow.UIView()

    init(initialContent: VFlow, finalContent: VFlow) {
        self.initialContent = initialContent
        self.finalContent = finalContent

        super.init(nibName: nil, bundle: nil)

        hidesBottomBarWhenPushed = true
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.tokens.backgroundColor = Colors.background.default

        context = context
            .componentViewController(self)
            .fallbackComponentCache(FallbackComponentCache())
            .textCache(TextCache())

        setupNavigationBar()
        setupContentView()
    }
}

extension TestViewController {

    private func setupNavigationBar() {
        navigationItem.title = "Test"

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Reset",
            style: .plain,
            target: self,
            action: #selector(onResetButtonTap)
        )
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

    private func updateContentView(strategy: FlowUpdateStrategy = .update) {
        contentView.update(
            with: initialContent.updateStrategy(strategy),
            context: context
        )

        Task {
            try? await Task.sleep(nanoseconds: 4_000_000_000)

            contentView.update(
                with: finalContent,
                context: context
            )
        }
    }
}

extension TestViewController {

    @objc
    private func onResetButtonTap() {
        updateContentView(strategy: .reload)
    }
}
