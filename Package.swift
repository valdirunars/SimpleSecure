import PackageDescription

let package = Package(
    name: "SimpleSecure",
    dependencies: [
        .Package(url: "https://github.com/IBM-Swift/Kitura.git", majorVersion: 1, minor: 2),
        .Package(url: "https://github.com/IBM-Swift/HeliumLogger.git", majorVersion: 0, minor: 6),
        .Package(url: "https://github.com/IBM-Swift/SwiftyJSON.git", majorVersion: 15),
        .Package(url: "https://github.com/kylef/JSONWebToken.swift.git", majorVersion: 2, minor: 0)
    ]
)
