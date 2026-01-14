#if canImport(UIKit)
import SwiftUI

public struct FlowContainerFooter<Content: Component>: @unchecked Sendable {

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

extension FlowContainerFooter: Hashable where Content: Hashable { }

extension FlowContainerFooter: FlowFooter {

    public typealias View = FlowContainerFooterView<Content>
}

extension FlowContainerFooter: Changeable {

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

extension View where Self: Equatable {

    public nonisolated func flowFooter() -> FlowContainerFooter<Self>
    where Self: Component {
        FlowContainerFooter(content: self)
    }

    public nonisolated func flowFooter(
        width: ComponentSizingStrategy = .hug,
        height: ComponentSizingStrategy = .hug,
        alignment: Alignment = .center
    ) -> FlowContainerFooter<some Component> {
        self
            .frame(width: width, height: height, alignment: alignment)
            .flowFooter()
    }
}

extension View where Self: Equatable {

    internal nonisolated func anyFlowFooter() -> any FlowFooter
    where Self: Component {
        flowFooter()
    }

    internal nonisolated func anyFlowFooter() -> any FlowFooter {
        if let component = self as? any Component {
            return component.anyFlowFooter()
        }

        return flowFooter()
    }
}
#endif
