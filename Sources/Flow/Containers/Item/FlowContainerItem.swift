#if canImport(UIKit)
import SwiftUI

public struct FlowContainerItem<Content: Component>: @unchecked Sendable {

    public let identifier: ComponentIdentifier
    public let content: Content

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
        identifier: some Hashable & Sendable,
        content: Content,
        accessibilityIdentifier: String? = nil,
        selectAction: (@MainActor (_ deselection: Deselection) -> Void)? = nil,
        deselectAction: (@MainActor () -> Void)? = nil,
        appearAction: (@MainActor () -> Void)? = nil,
        disappearAction: (@MainActor () -> Void)? = nil
    ) {
        self.identifier = ComponentIdentifier(identifier)
        self.content = content

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

    public nonisolated func flowItem(identifier: some Hashable & Sendable) -> FlowContainerItem<Self> {
        FlowContainerItem(
            identifier: identifier,
            content: self
        )
    }
}

extension View where Self: Equatable {

    public nonisolated func flowItem(
        identifier: some Hashable & Sendable,
        width: ComponentSizingStrategy = .hug,
        height: ComponentSizingStrategy = .hug,
        alignment: Alignment = .center
    ) -> FlowContainerItem<some Component> {
        self
            .frame(width: width, height: height, alignment: alignment)
            .flowItem(identifier: identifier)
    }
}
#endif
