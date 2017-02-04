import PackageDescription

let package = Package(
    name: "ChamomileBatch",
    dependencies: [
        .Package(url:"https://github.com/PerfectlySoft/Perfect-HTTPServer.git", majorVersion: 2, minor: 0),
        .Package(url:"https://github.com/PerfectlySoft/Perfect-MySQL.git", majorVersion: 2, minor: 0),
        .Package(url:"https://github.com/S-Shimotori/APIKit.git", Version(3, 1, 4))
    ]
)

