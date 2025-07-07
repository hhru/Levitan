#if canImport(UIKit)
import QuartzCore

@MainActor
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

    private func performNextOperation() {
        guard !operations.isEmpty else {
            return
        }

        performOperation(operations.removeFirst())
    }

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

extension TextOperationQueue: @preconcurrency CAAnimationDelegate {

    public func animationDidStop(_ animation: CAAnimation, finished: Bool) {
        performNextOperation()
    }
}
#endif
