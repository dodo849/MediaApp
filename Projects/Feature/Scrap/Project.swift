import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeFeatureModule(
    .scrap,
    dependencies: [
        .feature(.common)
    ]
)
