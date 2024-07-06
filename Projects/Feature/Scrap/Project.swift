import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeFeatureModule(
    .scrap,
    dependencies: [
        .feature(.common),
        .feature(.search),
        .network(.media),
        .database(.media),
    ]
)
