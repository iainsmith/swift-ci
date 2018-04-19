@testable import CILib
import XCTest

class CITests: XCTestCase {
    func testOrderedYAML() throws {
        let yaml = TravisYAML.standardSPM
        let string = try yaml.toYaml()

        let expected = """
        language: generic
        sudo: required
        dist: trusty
        env:
        - SWIFT_VERSION=4.0
        - SWIFT_VERSION=4.1
        os:
        - osx
        - linux
        osx_image: xcode9
        install:
        - eval "$(curl -sL https://swiftenv.fuller.li/en/latest/install.sh)"
        script:
        - set -o pipefail
        - swift test

        """

        XCTAssertEqual(string, expected)
    }

    static var allTests = [
        ("testTravisYAML", testOrderedYAML),
    ]
}
