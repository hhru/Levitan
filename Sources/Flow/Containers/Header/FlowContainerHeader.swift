#if canImport(UIKit)
import Foundation

public struct FlowContainerHeader<Content: Component> {

    public let content: Content

    public var accessibilityIdentifier: String?

    @ViewAction
    public var appearAction: (@MainActor () -> Void)?

    @ViewAction
    public var disappearAction: (@MainActor () -> Void)?

    public init(
        content: Content,
        accessibilityIdentifier: String? = nil,
        appearAction: (@MainActor () -> Void)? = nil,
        disappearAction: (@MainActor () -> Void)? = nil
    ) {
        self.content = content

        self.accessibilityIdentifier = accessibilityIdentifier

        self.appearAction = appearAction
        self.disappearAction = disappearAction
    }
}

extension FlowContainerHeader: FlowHeader {

    public typealias View = FlowContainerHeaderView<Content>
}

extension FlowContainerHeader: Changeable {

    public func accessibilityIdentifier(_ accessibilityIdentifier: String?) -> Self {
        changing { $0.accessibilityIdentifier = accessibilityIdentifier }
    }

    public func onAppear(_ action: (@MainActor () -> Void)?) -> Self {
        guard let action else {
            return self
        }

        let newAction = { @MainActor [appearAction] in
            appearAction?()
            action()
        }

        return changing { $0.appearAction = newAction }
    }

    public func onDisappear(_ action: (@MainActor () -> Void)?) -> Self {
        guard let action else {
            return self
        }

        let newAction = { @MainActor [disappearAction] in
            disappearAction?()
            action()
        }

        return changing { $0.disappearAction = newAction }
    }
}

extension Component {

    public func flowHeader() -> FlowContainerHeader<Self> {
        FlowContainerHeader(content: self)
    }
}
#endif
