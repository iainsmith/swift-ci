import XCTest
@testable import CILib

class CITests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(swift_ci().text, "Hello, World!")
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}
