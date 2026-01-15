import UIKit

final class PerformanceMonitorController: UIViewController {

    let window: PerformanceMonitorWindow

    init(window: PerformanceMonitorWindow) {
        self.window = window

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = PerformanceMonitor()
    }
}
