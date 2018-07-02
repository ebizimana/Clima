import PackageDescription

let package = Package(
    name: "Clima",
    targets: [
        Target(
            name: "Clima",
            dependencies: ["ClimaCore"]
        ),
        Target(name: "ClimaCore")
    ],
    dependencies: [
        .Package(
            url: "https://github.com/SwiftyJSON/SwiftyJSON.git",
            "4.0.0"
        ),
        .Package(url: "https://github.com/Alamofire/Alamofire.git", majorVersion: 4),
    ]
)
