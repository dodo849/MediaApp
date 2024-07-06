import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeFeatureModule(
    .search,
    dependencies: [
        .feature(.common),
        .core(.cache),
        .network(.media),
        .database(.media),
        .thirdParty(.kingfisher),
    ]
)
