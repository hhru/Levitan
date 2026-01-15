import UIKit

final class PerformanceMonitorWindow: UIWindow {

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        super
            .hitTest(point, with: event)
            .flatMap { $0 === self ? nil : $0 }
    }
}
