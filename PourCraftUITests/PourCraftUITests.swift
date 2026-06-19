import UIKit
import XCTest

final class PourCraftUITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        configureLaunchArguments()
    }

    private func configureLaunchArguments(autoAdvanceSteps: Bool = true) {
        app.launchArguments = [
            "-selectedRoast", "medium",
            "-temperatureUnit", "fahrenheit",
            "-hapticsEnabled", "YES",
            "-autoAdvanceSteps", autoAdvanceSteps ? "YES" : "NO",
            "-savedPresetRoast", "",
            "-savedPresetWeight", "0"
        ]
    }

    override func tearDownWithError() throws {
        XCUIDevice.shared.orientation = .portrait
        app = nil
    }

    func testCompactPhoneScreenshots() throws {
        try XCTSkipIf(UIDevice.current.userInterfaceIdiom != .phone, "Phone-only coverage")

        configureLaunchArguments(autoAdvanceSteps: false)
        XCUIDevice.shared.orientation = .portrait
        app.launch()

        assertExists(element("nav.tab.brew"))
        assertExists(element("brew.header.title"))
        assertExists(element("brew.begin"))
        XCTAssertFalse(element("nav.sidebar.brew").exists)
        captureScreenshot(named: "iPhone-Brew-Compact")

        element("nav.tab.guide").tap()
        assertExists(element("guide.header.title"))
        app.swipeUp()
        assertExists(element("guide.timer.primary"))
        assertExists(element("guide.step.1"))
        captureScreenshot(named: "iPhone-Guide-Compact")

        app.swipeDown()
        assertExists(element("guide.timer.title"))
        startTimerAndWaitForRunning()
        captureScreenshot(named: "iPhone-Timer-Running")

        element("nav.tab.tips").tap()
        assertExists(element("tips.header.title"))
        assertExists(element("tips.row.grind"))
        element("tips.row.grind").tap()
        assertExists(element("article.title.grind"))
        captureScreenshot(named: "iPhone-Tip-Article")
    }

    func testIPadWideScreenshotsAndSplitSelection() throws {
        try XCTSkipIf(UIDevice.current.userInterfaceIdiom != .pad, "iPad-only coverage")

        XCUIDevice.shared.orientation = .portrait
        app.launch()

        assertExists(element("nav.sidebar.brew"))
        assertExists(element("brew.header.title"))
        assertExists(element("brew.begin"))
        XCTAssertFalse(element("nav.tab.brew").exists)
        captureScreenshot(named: "iPad-Brew-Portrait")

        element("nav.sidebar.guide").tap()
        assertExists(element("guide.header.title"))
        assertExists(element("guide.timer.primary"))
        assertExists(element("guide.step.1"))
        captureScreenshot(named: "iPad-Guide-Portrait")

        startTimerAndWaitForRunning()
        captureScreenshot(named: "iPad-Timer-Running")

        element("nav.sidebar.tips").tap()
        assertExists(element("tips.header.title"))
        assertExists(element("tips.row.grind"))
        assertExists(element("article.title.grind"))
        captureScreenshot(named: "iPad-Tips-Split-Grind")

        element("tips.row.water").tap()
        assertExists(element("article.title.water"))
        XCTAssertEqual(element("tips.row.water").value as? String, "Selected")
        captureScreenshot(named: "iPad-Tips-Split-Water")
    }

    func testIPadLandscapeShellAndAccessibilityState() throws {
        try XCTSkipIf(UIDevice.current.userInterfaceIdiom != .pad, "iPad-only coverage")

        XCUIDevice.shared.orientation = .landscapeLeft
        app.launch()

        assertExists(element("nav.sidebar.brew"))
        assertExists(element("brew.header.title"))
        assertExists(element("brew.begin"))

        element("nav.sidebar.tips").tap()
        assertExists(element("tips.header.title"))
        assertExists(element("tips.row.grind"))
        assertExists(element("article.title.grind"))
        XCTAssertEqual(element("nav.sidebar.tips").value as? String, "Selected")

        element("tips.row.water").tap()
        assertExists(element("article.title.water"))
        XCTAssertEqual(element("tips.row.water").value as? String, "Selected")
        captureScreenshot(named: "iPad-Tips-Landscape-Water")
    }

    private func assertExists(
        _ element: XCUIElement,
        timeout: TimeInterval = 4,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        XCTAssertTrue(element.waitForExistence(timeout: timeout), file: file, line: line)
    }

    private func element(_ identifier: String) -> XCUIElement {
        app.descendants(matching: .any)[identifier]
    }

    private func startTimerAndWaitForRunning() {
        element("guide.timer.primary").tap()

        let phase = element("guide.timer.phase")
        assertExists(phase)

        let bloomPredicate = NSPredicate(format: "label CONTAINS[c] %@", "Bloom")
        expectation(for: bloomPredicate, evaluatedWith: phase)
        waitForExpectations(timeout: 3)

        let elapsed = element("guide.timer.elapsed")
        assertExists(elapsed)

        let elapsedPredicate = NSPredicate(format: "label != %@", "0:00")
        expectation(for: elapsedPredicate, evaluatedWith: elapsed)
        waitForExpectations(timeout: 3)
    }

    private func captureScreenshot(named name: String) {
        let screenshot = XCUIScreen.main.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)

        guard let directory = ProcessInfo.processInfo.environment["POURCRAFT_SCREENSHOT_DIR"],
              !directory.isEmpty else {
            return
        }

        let directoryURL = URL(fileURLWithPath: directory, isDirectory: true)
        do {
            try FileManager.default.createDirectory(
                at: directoryURL,
                withIntermediateDirectories: true
            )
            try screenshot.pngRepresentation.write(
                to: directoryURL.appendingPathComponent("\(sanitized(name)).png")
            )
        } catch {
            XCTFail("Failed to export screenshot \(name): \(error)")
        }
    }

    private func sanitized(_ name: String) -> String {
        let allowed = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "-_"))
        return name.unicodeScalars.map { scalar in
            allowed.contains(scalar) ? Character(scalar) : Character("-")
        }.reduce(into: "") { partialResult, character in
            partialResult.append(character)
        }
    }
}
