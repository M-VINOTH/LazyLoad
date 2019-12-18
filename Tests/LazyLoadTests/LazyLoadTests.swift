import XCTest
@testable import LazyLoad

final class LazyLoadTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(LazyLoad().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
