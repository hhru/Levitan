#if canImport(UIKit)
import Foundation

public struct ListContainerItem<Content: Component>: ListItem {

    public typealias Cell = ListContainerCell<Content>

    public let content: Content
    public let identifier: AnyHashable

    public var accessibilityIdentifier: String?

    @ViewAction
    public var selectAction: ((_ deselection: Deselection) -> Void)?

    @ViewAction
    public var deselectAction: (() -> Void)?

    @ViewAction
    public var appearAction: (() -> Void)?

    @ViewAction
    public var disappearAction: (() -> Void)?

    public init(
        content: Content,
        identifier: AnyHashable,
        accessibilityIdentifier: String? = nil,
        selectAction: ((_ deselection: Deselection) -> Void)? = nil,
        deselectAction: (() -> Void)? = nil,
        appearAction: (() -> Void)? = nil,
        disappearAction: (() -> Void)? = nil
    ) {
        self.content = content

        self.identifier = identifier
        self.accessibilityIdentifier = accessibilityIdentifier

        self.selectAction = selectAction
        self.deselectAction = deselectAction

        self.appearAction = appearAction
        self.disappearAction = disappearAction
    }
}

extension ListContainerItem: Changeable {

    public func accessibilityIdentifier(_ accessibilityIdentifier: String?) -> Self {
        changing { $0.accessibilityIdentifier = accessibilityIdentifier }
    }

    public func onSelect(_ action: ((_ deselection: Deselection) -> Void)?) -> Self {
        guard let action else {
            return self
        }

        let newAction = { [selectAction] deselection in
            selectAction?(deselection)
            action(deselection)
        }

        return changing { $0.selectAction = newAction }
    }

    public func onSelect(_ action: (() -> Void)?) -> Self {
        guard let action else {
            return self
        }

        let newAction = { [selectAction] deselection in
            selectAction?(deselection)
            action()
        }

        return changing { $0.selectAction = newAction }
    }

    public func onDeselect(_ action: (() -> Void)?) -> Self {
        guard let action else {
            return self
        }

        let newAction = { [deselectAction] in
            deselectAction?()
            action()
        }

        return changing { $0.deselectAction = newAction }
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

    public func listItem(identifier: AnyHashable) -> ListContainerItem<Self> {
        ListContainerItem(
            content: self,
            identifier: identifier
        )
    }

    public func listItem(file: String = #fileID, line: Int = #line) -> ListContainerItem<Self> {
        listItem(identifier: "\(file):\(line)")
    }
}
#endif
