#if canImport(UIKit)
import Foundation

public struct ListContainerFooter<Content: Component>: ListFooter {

    public typealias View = ListContainerFooterView<Content>

    public let content: Content

    public var accessibilityIdentifier: String?

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

extension ListContainerFooter: Changeable {

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

    public func listFooter() -> ListContainerFooter<Self> {
        ListContainerFooter(content: self)
    }
}
#endif
