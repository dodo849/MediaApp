import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeDIModule(
    .navigation,
    dependencies: [
        .feature(.scrap),
        .feature(.search)
    ]
)
