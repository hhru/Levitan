import Foundation

public struct ListContainerHeader<Content: Component>: ListHeader {

    public typealias View = ListContainerHeaderView<Content>

    public let content: Content

    public let accessibilityIdentifier: String?

    @ViewAction
    public var appearAction: (() -> Void)?

    @ViewAction
    public var disappearAction: (() -> Void)?

    public init(
        content: Content,
        accessibilityIdentifier: String? = nil,
        appearAction: (() -> Void)? = nil,
        disappearAction: (() -> Void)? = nil
    ) {
        self.content = content

        self.accessibilityIdentifier = accessibilityIdentifier

        self.appearAction = appearAction
        self.disappearAction = disappearAction
    }
}

extension ListContainerHeader: Changeable {

    internal init(copy: ChangeableWrapper<Self>) {
        self.content = copy.content

        self.accessibilityIdentifier = copy.accessibilityIdentifier

        self.appearAction = copy.appearAction
        self.disappearAction = copy.disappearAction
    }

    public func accessibilityIdentifier(_ accessibilityIdentifier: String?) -> Self {
        changing { $0.accessibilityIdentifier = accessibilityIdentifier }
    }

    public func onAppear(_ action: (() -> Void)?) -> Self {
        guard let action else {
            return self
        }

        let newAction = { [appearAction] in
            appearAction?()
            action()
        }

        return changing { $0.appearAction = newAction }
    }

    public func onDisappear(_ action: (() -> Void)?) -> Self {
        guard let action else {
            return self
        }

        let newAction = { [disappearAction] in
            disappearAction?()
            action()
        }

        return changing { $0.disappearAction = newAction }
    }
}

extension Component {

    public func listHeader() -> ListContainerHeader<Self> {
        ListContainerHeader(content: self)
    }
}
