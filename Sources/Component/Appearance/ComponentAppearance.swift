#if canImport(UIKit)
import Foundation

@MainActor
public final class ComponentAppearance {

    private weak var view: ComponentAppearanceView?

    private var superview: ComponentAppearance?
    private var subviews: [ComponentSubviewAppearanceStorage] = []

    private var isSuperviewExist = true {
        didSet { updateExistence() }
    }

    private var isViewExist = true {
        didSet { updateExistence() }
    }

    public private(set) var isExist = true

    public nonisolated init() { }
}

extension ComponentAppearance {

    private func updateExistence() {
        let isExist = isSuperviewExist && isViewExist

        guard self.isExist != isExist else {
            return
        }

        self.isExist = isExist

        if isExist {
            view?.onViewAppear()

            subviews
                .compactMap { $0.appearance }
                .forEach { $0.onSuperviewAppear() }
        } else {
            view?.onViewDisappear()

            subviews
                .compactMap { $0.appearance }
                .forEach { $0.onSuperviewDisappear() }
        }
    }

    private func updateSubviews(appending appearance: ComponentSubviewAppearance) {
        let storage = ComponentSubviewAppearanceStorage(appearance: appearance)

        subviews = subviews
            .filter { $0.appearance != nil }
            .appending(storage)
    }

    private func updateSubviews(removing appearance: ComponentSubviewAppearance) {
        subviews = subviews
            .lazy
            .filter { $0.appearance != nil }
            .filter { $0.appearance !== appearance }
    }
}

extension ComponentAppearance {

    public func onViewAppear() {
        self.isViewExist = true
    }

    public func onViewDisappear() {
        self.isViewExist = false
    }
}

extension ComponentAppearance: ComponentSuperviewAppearance {

    public func connectAppearance(
        _ appearance: ComponentAppearance,
        of view: ComponentAppearanceView
    ) {
        guard appearance.superview !== self else {
            return
        }

        if let superview = appearance.superview {
            superview.updateSubviews(removing: appearance)
        }

        appearance.view = view
        appearance.superview = self

        updateSubviews(appending: appearance)
    }
}

extension ComponentAppearance: ComponentSubviewAppearance {

    public func onSuperviewAppear() {
        isSuperviewExist = true
    }

    public func onSuperviewDisappear() {
        isSuperviewExist = false
    }
}
#endif
