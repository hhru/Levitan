#if canImport(UIKit)
import SwiftUI
import XCTest

@testable import Levitan

@MainActor
final class ComponentContextTests: XCTestCase {

    // MARK: - Overrides

    func testOverriddenValueIsResolved() {
        let id = ComponentID("overridden")
        let context = ComponentContext.default.componentID(id)

        XCTAssertEqual(context.componentID.value, id)
    }

    func testLatestOverrideWins() {
        let firstID = ComponentID("first")
        let secondID = ComponentID("second")

        let context = ComponentContext
            .default
            .componentID(firstID)
            .componentID(secondID)

        XCTAssertEqual(context.componentID.value, secondID)
    }

    func testOverrideWithNilIsResolved() {
        let context = ComponentContext.default
            .componentID(ComponentID("overridden"))
            .componentID(nil)

        XCTAssertNil(context.componentID.value)
    }

    func testNotOverriddenValueIsResolvedFromEnvironment() {
        let id = ComponentID("environment")
        var environment = EnvironmentValues()

        environment.componentID = id

        let context = environment
            .componentContext
            .disabled()

        XCTAssertEqual(context.componentID.value, id)
        XCTAssertFalse(context.isEnabled.value)
    }

    func testResolvedEnvironmentKeepsBaseValues() {
        let firstID = ComponentID("first")
        let secondID = ComponentID("second")
        let dynamicTypeSize = DynamicTypeSize.xxxLarge

        var environment = EnvironmentValues()

        environment.dynamicTypeSize = dynamicTypeSize

        let context = ComponentContext
            .default
            .componentID(firstID)
            .componentID(secondID)

        let resolvedEnvironment = context.resolveEnvironment(environment)

        XCTAssertEqual(resolvedEnvironment.componentID, secondID)
        XCTAssertEqual(resolvedEnvironment.dynamicTypeSize, dynamicTypeSize)
    }

    // MARK: - Disable

    func testDisabledCannotBeReverted() {
        let context = ComponentContext.default
            .disabled(true)
            .disabled(false)

        XCTAssertFalse(context.isEnabled.value)
    }

    func testDisabledKeepsDisabledEnvironment() {
        var environment = EnvironmentValues()

        environment.isEnabled = false

        let context = environment
            .componentContext
            .disabled(false)

        XCTAssertFalse(context.isEnabled.value)
    }

    func testDirectOverrideIsVisibleThroughAlias() {
        let context = ComponentContext
            .default
            .isDisabledAlternatively(false)
            .disabled(true)

        XCTAssertTrue(context.isDisabledAlternatively.value)
        XCTAssertFalse(context.isEnabled.value)
    }

    func testAliasOverrideIsVisibleThroughDirectKey() {
        let context = ComponentContext.default
            .disabled(true)
            .isDisabledAlternatively(false)

        XCTAssertTrue(context.isEnabled.value)
        XCTAssertFalse(context.isDisabledAlternatively.value)
    }
}

extension EnvironmentValues {

    /// Прокси-свойство, которое читает и пишет isEnabled.
    fileprivate var isDisabledAlternatively: Bool {
        get { !isEnabled }
        set { isEnabled = !newValue }
    }
}
#endif
