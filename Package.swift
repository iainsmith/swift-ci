// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-ci",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .executable(
            name: "swift-ci",
            targets: ["CI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/kylef/Commander", from: "0.8.0"),
        .package(url: "https://github.com/iainsmith/TravisClient", .exact(Version(0, 2, 1, prereleaseIdentifiers: ["beta"]))),
        .package(url: "https://github.com/jpsim/Yams.git", from: "0.7.0"),
        .package(url: "https://github.com/JohnSundell/ShellOut", from: "2.1.0"),
        .package(url: "https://github.com/onevcat/Rainbow", from: "3.1.2"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "CI",
            dependencies: ["CILib"]),
        .target(
            name: "CILib",
            dependencies: ["Yams", "TravisClient", "Commander", "ShellOut", "Rainbow"]),
        .testTarget(
            name: "CITests",
            dependencies: ["CILib"]),
    ]
)
