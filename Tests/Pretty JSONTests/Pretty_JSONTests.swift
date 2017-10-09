import XCTest
@testable import Pretty_JSON

class Pretty_JSONTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Pretty_JSON().text, "Hello, World!")
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}
