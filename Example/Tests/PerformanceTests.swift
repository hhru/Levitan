import XCTest

@MainActor
final class PerformanceTests: XCTestCase {

    let application = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testThatScreenTitleIsCorrect() {
        application.launch()

        let debugTap = application
            .tabBars
            .buttons["Debug"]
            .firstMatch

        XCTAssertTrue(debugTap.waitForExistence(timeout: 2))

        debugTap.tap()

        let measurePerformanceButton = application
            .buttons["⏱️  Measure performance"]
            .firstMatch

        XCTAssertTrue(measurePerformanceButton.waitForExistence(timeout: 2))

        measurePerformanceButton.tap()

        let contentView = application
            .collectionViews
            .firstMatch

        XCTAssertTrue(contentView.waitForExistence(timeout: 2))

        measure(
            metrics: [
                XCTOSSignpostMetric.scrollingAndDecelerationMetric,
                XCTCPUMetric(application: application)
            ]
        ) {
            contentView.swipeUp()
        }
    }
}
