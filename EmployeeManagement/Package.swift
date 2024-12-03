// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "EmployeeManagement",
    platforms: [
        .macOS(.v10_15)
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/mysql-nio.git", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.32.0"),
    ],
    targets: [
        .executableTarget(
            name: "EmployeeManagement",
            dependencies: [
                .product(name: "MySQLNIO", package: "mysql-nio"),
                .product(name: "NIO", package: "swift-nio"),
            ]),
    ]
)
