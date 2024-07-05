import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeNetworkModule(
    .media,
    dependencies: [
        .network(.common)
    ]
)
