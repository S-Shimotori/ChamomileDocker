import PackageDescription

let package = Package(
    name: "ChamomileBatch",
    dependencies: [
        .Package(url:"https://github.com/thoughtbot/Argo", Version(4, 1, 2)),
        .Package(url:"https://github.com/thoughtbot/Curry", Version(3, 0, 0)),
        .Package(url:"https://github.com/noppoMan/SwiftKnex", Version(0, 1, 9)),
        .Package(url:"https://github.com/S-Shimotori/APIKit.git", Version(3, 1, 6)),
    ]
)

