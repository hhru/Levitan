#if canImport(UIKit)
import QuartzCore

internal class TextOperationQueue: NSObject {

    private var operations: [TextOperation] = []

    internal let layer: CALayer

    internal var isRunning: Bool {
        if !operations.isEmpty {
            return true
        }

        return layer.animationKeys()?.contains { key in
            layer.animation(forKey: key)?.delegate === self
        } ?? false
    }

    internal init(layer: CALayer) {
        self.layer = layer
    }

    @MainActor
    private func performOperation(_ operation: TextOperation) {
        let transition = operation
            .animation?
            .caTransition
            .resolve(for: layer.tokens.theme)

        if let transition {
            transition.delegate = self

            layer.add(
                transition,
                forKey: "\(Self.self)"
            )

            return operation.action()
        }

        operation.action()

        performNextOperation()
    }

    @MainActor
    private func performNextOperation() {
        guard !operations.isEmpty else {
            return
        }

        performOperation(operations.removeFirst())
    }

    @MainActor
    internal func addOperation(animation: AnimationToken? = nil, _ action: @escaping () -> Void) {
        let operation = TextOperation(
            animation: animation,
            action: action
        )

        if isRunning {
            operations.append(operation)
        } else {
            performOperation(operation)
        }
    }

    internal func reset() {
        operations.removeAll(keepingCapacity: true)
    }
}

extension TextOperationQueue: CAAnimationDelegate {

    public func animationDidStop(_ animation: CAAnimation, finished: Bool) {
        Task { @MainActor in
            performNextOperation()
        }
    }
}
#endif
