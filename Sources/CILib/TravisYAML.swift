import Yams

class TravisYAML: Codable {
    let language: String
    let sudo: String
    let dist: String
    let osxImage: String
    let env: [String]
    let os: [String]
    let install: [String]
    let script: [String]

    public init(language: String, sudo: String, dist: String, osxImage: String, env: [String], os: [String], install: [String], script: [String]) {
        self.language = language
        self.sudo = sudo
        self.dist = dist
        self.osxImage = osxImage
        self.env = env
        self.os = os
        self.install = install
        self.script = script
    }

    enum CodingKeys: String, CodingKey {
        case language
        case sudo
        case dist
        case env
        case os
        case osxImage = "osx_image"
        case install
        case script
    }

    public static let standardSPM: TravisYAML = {
        TravisYAML(language: "generic",
                   sudo: "required",
                   dist: "trusty",
                   osxImage: "xcode9",
                   env: ["SWIFT_VERSION=4.0", "SWIFT_VERSION=4.1"],
                   os: ["osx", "linux"],
                   install: ["eval \"$(curl -sL https://swiftenv.fuller.li/en/latest/install.sh)\""],
                   script: [
                       "set -o pipefail",
                       "swift test",
        ])
    }()

    public func toYaml() throws -> String {
        return try YAMLEncoder().encode(self)
    }
}
