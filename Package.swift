// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Additions",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Additions",
            targets: ["Additions"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Additions",
            dependencies: [
                "AdditionsCore",
                "AppKitAdditions",
                "CollectionsAdditions",
                //"CombinationsAndPermutationsAdditions",
                "CoreGraphicsAdditions",
                "DispatchAdditions",
                "FoundationAdditions",
                //"NSStringAdditions",
                //"SceneKitAdditions",
                "Yield"
            ]
        ),
        .target(name: "AdditionsCore"),
        .target(
            name: "AppKitAdditions",
            dependencies: ["CoreGraphicsAdditions"]
        ),
        .target(
            name: "CollectionsAdditions",
            dependencies: ["AdditionsCore", "CoreGraphicsAdditions"]
        ),
        //.target(name: "CombinationsAndPermutationsAdditions"),
        .target(
            name: "CoreGraphicsAdditions",
            dependencies: ["AdditionsCore"]
        ),
        .target(name: "DispatchAdditions"),
        .target(
            name: "FoundationAdditions",
            dependencies: ["CollectionsAdditions"]
        ),
        //.target(name: "NSStringAdditions"),
        //.target(name: "SceneKitAdditions"),
        .target(
            name: "Yield",
            exclude: ["LICENSE", "README.md", "Package.swift"]
        ),
        
        .testTarget(
            name: "AdditionsTests",
            dependencies: ["Additions"]),
    ]
)
