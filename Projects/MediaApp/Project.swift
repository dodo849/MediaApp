import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeMainApp(
    appName: "MediaApp",
    dependencies: [
        .feature(.scrap) // Root view
    ]
)
