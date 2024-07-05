import Foundation
import ProjectDescription

extension TargetScript {
    static let swiftlint: TargetScript = .pre(
        script: """
        ROOT_DIR=\(ProcessInfo.processInfo.environment["TUIST_ROOT_DIR"] ?? "")
                
        ${ROOT_DIR}/swiftlint --config ${ROOT_DIR}/.swiftlint.yml
                
        """,
        name: "SwiftLint",
        basedOnDependencyAnalysis: false
      )
}
