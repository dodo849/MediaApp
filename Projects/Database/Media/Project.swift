import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeDatabaseModule(
    .media,
    dependencies: [
        .database(.common)
    ]
)
