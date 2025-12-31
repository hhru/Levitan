#if canImport(UIKit)
import Foundation

public struct FlowContainerItem<Content: Component> {

    public let content: Content
    public let identifier: AnyHashable

    public var accessibilityIdentifier: String?

    @ViewAction
    public var selectAction: (@MainActor (_ deselection: Deselection) -> Void)?

    @ViewAction
    public var deselectAction: (@MainActor () -> Void)?

    @ViewAction
    public var appearAction: (@MainActor () -> Void)?

    @ViewAction
    public var disappearAction: (@MainActor () -> Void)?

    public init(
        content: Content,
        identifier: AnyHashable,
        accessibilityIdentifier: String? = nil,
        selectAction: (@MainActor (_ deselection: Deselection) -> Void)? = nil,
        deselectAction: (@MainActor () -> Void)? = nil,
        appearAction: (@MainActor () -> Void)? = nil,
        disappearAction: (@MainActor () -> Void)? = nil
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

extension FlowContainerItem: FlowItem {

    public typealias Cell = FlowContainerCell<Content>
}

extension FlowContainerItem: Changeable {

    public func accessibilityIdentifier(_ accessibilityIdentifier: String?) -> Self {
        changing { $0.accessibilityIdentifier = accessibilityIdentifier }
    }

    public func onSelect(_ action: (@MainActor (_ deselection: Deselection) -> Void)?) -> Self {
        guard let action else {
            return self
        }

        let newAction = { @MainActor [selectAction] deselection in
            selectAction?(deselection)
            action(deselection)
        }

        return changing { $0.selectAction = newAction }
    }

    public func onSelect(_ action: (@MainActor () -> Void)?) -> Self {
        guard let action else {
            return self
        }

        let newAction = { @MainActor [selectAction] deselection in
            selectAction?(deselection)
            action()
        }

        return changing { $0.selectAction = newAction }
    }

    public func onDeselect(_ action: (@MainActor () -> Void)?) -> Self {
        guard let action else {
            return self
        }

        let newAction = { @MainActor [deselectAction] in
            deselectAction?()
            action()
        }

        return changing { $0.deselectAction = newAction }
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

    public func listItem(identifier: AnyHashable) -> FlowContainerItem<Self> {
        FlowContainerItem(
            content: self,
            identifier: identifier
        )
    }

    public func listItem(file: String = #fileID, line: Int = #line) -> FlowContainerItem<Self> {
        listItem(identifier: "\(file):\(line)")
    }
}
#endif
