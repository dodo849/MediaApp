import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeFeatureModule(
    .search,
    dependencies: [
        .feature(.common),
        .core(.cache),
        .network(.common),
        .network(.media),
        .database(.media),
        .thirdParty(.kingfisher),
    ]
)
