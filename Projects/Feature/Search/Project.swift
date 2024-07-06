import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeFeatureModule(
    .search,
    dependencies: [
        .feature(.common),
        .network(.media),
    ]
)
