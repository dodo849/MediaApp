//
//  PersistenceImageRepository.swift
//  MediaNetwork
//
//  Created by DOYEON LEE on 7/6/24.
//

import OSLog

import RealmSwift
import Dependencies

public class PersistenceImageRepository {
    private let realmThreadLabel = "com.realm.image"
    private let logger = Logger(
        subsystem: Bundle.module.bundleIdentifier!,
        category: "PersistenceImageRepository"
    )
    
    public init() { }
    
    public func saveScrapImage(_ model: PersistenceScrapImageModel) {
        DispatchQueue(label: realmThreadLabel).async {
            autoreleasepool {
                do {
                    let realm = try Realm()
                    try realm.write {
                        realm.add(model)
                    }
                } catch {
                    self.logger.error("Failed to save image info: \(error.localizedDescription)")
                }
            }
        }
    }
    
    public func getAllScrapImage() async throws -> [PersistenceScrapImageModel] {
        try await withCheckedThrowingContinuation { continuation in
            DispatchQueue(label: realmThreadLabel).async {
                autoreleasepool {
                    do {
                        let realm = try Realm().freeze() // Read only
                        let results = realm.objects(PersistenceScrapImageModel.self)
                        continuation.resume(returning: Array(results))
                    } catch {
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }

    public func deleteScrapImage(byImageID imageID: String) {
        DispatchQueue(label: realmThreadLabel).async { [weak self] in
            autoreleasepool {
                guard let self = self else { return }
                do {
                    let realm = try Realm()
                    try realm.write {
                        if let imageToDelete = realm
                            .objects(PersistenceScrapImageModel.self)
                            .filter("imageID == %@", imageID)
                            .first {
                            realm.delete(imageToDelete)
                        } else {
                            self.logger.warning("Image with imageID \(imageID) not found in database.")
                        }
                    }
                } catch {
                    self.logger.error("Failed to delete image info: \(error.localizedDescription)")
                }
            }
        }
    }
}

// MARK: - Dependency
private enum PersistenceImageRepositoryKey: DependencyKey {
    static let liveValue: PersistenceImageRepository = PersistenceImageRepository()
}

public extension DependencyValues {
  var persistenceImageRepository: PersistenceImageRepository {
    get { self[PersistenceImageRepositoryKey.self] }
    set { self[PersistenceImageRepositoryKey.self] = newValue }
  }
}
