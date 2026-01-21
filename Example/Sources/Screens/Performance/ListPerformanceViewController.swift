import Levitan
import SwiftUI
import UIKit

final class ListPerformanceViewController: UIHostingController<AnyView> {

    private let performanceTracker = PerformanceTracker.shared
    private let usersStore = UsersStore.shared

    init() {
        super.init(rootView: AnyView(EmptyView()))
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.tokens.backgroundColor = Colors.background.default

        setupNavigationBar()
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

extension ListPerformanceViewController {

    private func setupNavigationBar() {
        navigationItem.title = "List"

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Close",
            style: .plain,
            target: self,
            action: #selector(onCloseButtonTap)
        )
    }

    private func updateContentView() {
        let users = usersStore.users

        let content = List(
            Array(users.enumerated()),
            id: \.element.id
        ) { [weak self] index, user in
            self?.userItem(
                user: user,
                isLast: index >= users.count - 1
            )
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: .zero, leading: .zero, bottom: .zero, trailing: .zero))
        }
        .listRowSeparator(.hidden)
        .listRowInsets(EdgeInsets(top: .zero, leading: .zero, bottom: .zero, trailing: .zero))
        .listRowSpacing(.zero)
        .listStyle(.plain)

        rootView = AnyView(content)
    }

    private func scrollToEndGradually() {
        guard let scrollView = scrollView(in: view) else {
            return
        }

        scrollToEndGradually(scrollView: scrollView)
    }

    private func scrollToEndGradually(scrollView: UIScrollView) {
        Task {
            await scrollToEndGradually(scrollView: scrollView)

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

    private func scrollToEndGradually(scrollView: UIScrollView) async {
        try? await Task.sleep(seconds: 1.5)

        let containerHeight = scrollView.frame.height
        let contentHeight = scrollView.contentSize.height
        let contentOffset = scrollView.contentOffset.y

        let maxContentOffset = contentHeight
            - containerHeight
            + scrollView.safeAreaInsets.bottom

        guard contentOffset < maxContentOffset - 1.0 else {
            return
        }

        let nextContentOffset = CGPoint(
            x: scrollView.contentOffset.x,
            y: min(
                contentOffset + containerHeight * 0.5,
                maxContentOffset
            )
        )

        scrollView.setContentOffset(
            nextContentOffset,
            animated: true
        )

        await scrollToEndGradually(scrollView: scrollView)
    }
}

extension ListPerformanceViewController {

    private func userItem(user: User, isLast: Bool) -> some View {
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

    private func scrollView(in view: UIView) -> UIScrollView? {
        if let scrollView = view as? UIScrollView {
            return scrollView
        }

        return view
            .subviews
            .lazy
            .compactMap { self.scrollView(in: $0) }
            .first
    }
}

extension ListPerformanceViewController {

    @objc
    private func onCloseButtonTap() {
        dismiss(animated: true)
    }
}
