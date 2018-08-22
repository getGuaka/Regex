import XCTest
@testable import Regex

class RegexTests: XCTestCase {

    func testItCanMatchASimpleString() {
        let r = try! Regex(pattern: "Hello (Name|name)")

        XCTAssertTrue(r.matches("Hello Name"))
        XCTAssertTrue(r.matches("Hello name"))
    }

    func testItMoreComplicatedStuff() {
        let r = try! Regex(pattern: "Hello [a-z]+ame")

        XCTAssertTrue(r.matches("Hello name"))
        XCTAssertTrue(r.matches("Hello fame"))
        XCTAssertFalse(r.matches("Hello Name"))
    }

    func testItCaptureAGroup() {
        let r = try! Regex(pattern: "Hello (.*) name")

        XCTAssertEqual(r.captures(string: "Hello mr name")[0].string, "mr")
        XCTAssertEqual(r.captures(string: "Hello dr name")[0].string, "dr")
    }

    func testItCaptureMultipleStrings() {
        let r = try! Regex(pattern: "Hello (.*) name (th[a-z]+s) is ([a-z]*)")

        XCTAssertEqual(r.captures(string: "Hello mr name this is omar").map({ $0.string }),
                       ["mr", "this", "omar"])
        XCTAssertEqual(r.captures(string: "Hello dr name this is the nurse").map({ $0.string }),
                       ["dr", "this", "the"])
    }

    func testItHandlesNoCaptures() {
        let r = try! Regex(pattern: "Hello (.*) name (th[a-z]+s) is ([a-z]*)")

        XCTAssertEqual(r.captures(string: "abcdefg").count, 0)
    }

    func testItReplacesStringInRange() {
        let s = "Hello my name"
        let fi = s.index(s.startIndex, offsetBy: 6)
        let si = s.index(s.startIndex, offsetBy: 8)
        let new = s.replacing(range: fi..<si, withString: "this")

        XCTAssertEqual(new, "Hello this name")
    }

    func testItReplacesPatternWithString() {
        let s = "Hello my name"
        let new = s.replacing(pattern: "my", withString: "this")

        XCTAssertEqual(new, "Hello this name")
    }

    func testItReplacesPatternWithStringMultipleTimes() {
        let s = "Hello my name my name my name"
        let new = s.replacing(pattern: "my", withString: "this")

        XCTAssertEqual(new, "Hello this name this name this name")
    }

    func testItReplacesStringWithString() {
        let s = "Hello my name"
        let new = s.replacing(pattern: "my", withString: "this")

        XCTAssertEqual(new, "Hello this name")
    }

    func testItReplacesStringWithStringMultipleTimes() {
        let s = "Hello my name my name my name"
        let new = s.replacing(pattern: "my", withString: "this")

        XCTAssertEqual(new, "Hello this name this name this name")
    }

    func testTheOperator() {
        let s = "Hello dr name this is bla bla bla"
        let r = try! Regex(pattern: "Hello .* name th[a-z]+s .*")

        XCTAssertTrue(s ~= r)
        XCTAssertTrue(r ~= s)
    }

    func testItCanBeMatchedInASwitch() {

        switch "Hello dr name this is bla bla bla" {
        case try! Regex(pattern: "Hello .* name th[a-z]+s .*"):
            break
        default:
            XCTFail()
        }

        switch try! Regex(pattern: "Hello .* name th[a-z]+s .*") {
        case "Hello dr name this is bla bla bla":
            break
        default:
            XCTFail()
        }
    }

    func testItHandlesWrongPatterns() {
        do {
            _ = try Regex(pattern: "\\/\\/\\/\\")
            XCTFail()
        } catch is RegexError {

        } catch {
            XCTFail()
        }
    }

    static var allTests : [(String, (RegexTests) -> () throws -> Void)] {
        return [
            ("testItCanMatchASimpleString", testItCanMatchASimpleString),
            ("testItMoreComplicatedStuff", testItMoreComplicatedStuff),
            ("testItCaptureAGroup", testItCaptureAGroup),
            ("testItCaptureMultipleStrings", testItCaptureMultipleStrings),
            ("testItHandlesNoCaptures", testItHandlesNoCaptures),
            ("testItReplacesStringInRange", testItReplacesStringInRange),
            ("testItReplacesPatternWithString", testItReplacesPatternWithString),
            ("testItReplacesPatternWithStringMultipleTimes", testItReplacesPatternWithStringMultipleTimes),
            ("testItReplacesStringWithString", testItReplacesStringWithString),
            ("testItReplacesStringWithStringMultipleTimes", testItReplacesStringWithStringMultipleTimes),
            ("testTheOperator", testTheOperator),
            ("testItCanBeMatchedInASwitch", testItCanBeMatchedInASwitch),
            ("testItHandlesWrongPatterns", testItHandlesWrongPatterns)
        ]
    }
}
