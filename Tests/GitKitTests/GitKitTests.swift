    import XCTest
    @testable import GitKit

    final class GitKitTests: XCTestCase {
        func testExample() {
            // This is an example of a functional test case.
            // Use XCTAssert and related functions to verify your tests produce the correct
            // results.
            XCTAssertEqual(GitKit().text, "Hello, World!")
        }
    }
