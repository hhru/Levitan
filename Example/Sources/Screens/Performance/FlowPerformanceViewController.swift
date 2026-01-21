import Levitan
import SwiftUI
import UIKit

final class FlowPerformanceViewController: UIViewController {

    private let performanceTracker = PerformanceTracker.shared
    private let usersStore = UsersStore.shared

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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        UIApplication.shared.isIdleTimerDisabled = true

        performanceTracker.reset()
        performanceTracker.start()
        performanceTracker.showMonitor()

        scrollToEndGradually()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        performanceTracker.hideMonitor()
        performanceTracker.stop()

        UIApplication.shared.isIdleTimerDisabled = false
    }
}

extension FlowPerformanceViewController {

    private func setupNavigationBar() {
        navigationItem.title = "Flow"

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Close",
            style: .plain,
            target: self,
            action: #selector(onCloseButtonTap)
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

    private func updateContentView() {
        let users = usersStore.users

        let content = VFlow(
            itemsData: Array(users.enumerated()),
            itemsID: \.element.id,
            items: { index, user in
                userItem(
                    user: user,
                    isLast: index >= users.count - 1
                )
            }
        )
        .contentMarginsAdjustmentBehavior(.always)
        .scrollAlwaysBounces()

        contentView.update(
            with: content,
            context: context
        )
    }

    private func scrollToEndGradually() {
        Task {
            await scrollToEndGradually()

            let meanFPS = String(
                format: "Mean FPS: %.1f (min: %.1f max: %.1f)",
                performanceTracker.meanFPS,
                performanceTracker.minFPS,
                performanceTracker.maxFPS
            )

            let hitches = String(
                format: "Hitches: %.2f ms (rate: %.2f ms/s)",
                performanceTracker.hitchDuration * 1000.0,
                performanceTracker.hitchRate
            )

            let hangs = String(
                format: "Hangs: %.2f ms (rate: %.2f s/h)",
                performanceTracker.hangDuration * 1000.0,
                performanceTracker.hangRate
            )

            let results = """
                \(meanFPS)
                \(hitches)
                \(hangs)
                """

            let alert = Alert(
                title: "Performance",
                message: results,
                actions: [.cancel(title: "Cancel")]
            )

            showAlert(alert)
        }
    }

    private func scrollToEndGradually() async {
        try? await Task.sleep(seconds: 1.5)

        let containerHeight = contentView.frame.height
        let contentHeight = contentView.contentSize.height
        let contentOffset = contentView.contentOffset.y

        let maxContentOffset = contentHeight
            - containerHeight
            + contentView.safeAreaInsets.bottom

        guard contentOffset < maxContentOffset - 1.0 else {
            return
        }

        let nextContentOffset = CGPoint(
            x: contentView.contentOffset.x,
            y: min(
                contentOffset + containerHeight * 0.5,
                maxContentOffset
            )
        )

        contentView.setContentOffset(
            nextContentOffset,
            animated: true
        )

        await scrollToEndGradually()
    }
}

extension FlowPerformanceViewController {

    private func userItem(user: User, isLast: Bool) -> some Component {
        Cell(
            avatar: Avatar(
                url: nil,
                placeholder: Image(.avatarPlaceholder),
                size: .small
            ),
            title: user.name,
            subtitle: user.description,
            action: nil,
            divider: !isLast,
            tapAction: nil
        )
    }
}

extension FlowPerformanceViewController {

    @objc
    private func onCloseButtonTap() {
        dismiss(animated: true)
    }
}
