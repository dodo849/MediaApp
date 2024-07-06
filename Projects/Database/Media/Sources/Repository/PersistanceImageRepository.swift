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
    private let logger = Logger(
        subsystem: Bundle.module.bundleIdentifier!,
        category: "PersistenceImageRepository"
    )
    private var realm: Realm
    
    public init() {
        do {
            self.realm = try Realm()
        } catch {
            fatalError("Failed to instantiate Realm. Error: \(error.localizedDescription)")
        }
    }
    
    public func saveScrapImage(_ model: PersistenceScrapImageModel) {
        do {
            try realm.write {
                realm.add(model)
            }
        } catch {
            logger.error("Failed to save image info: \(error.localizedDescription)")
        }
    }
    
    public func getAllScrapImage() -> Results<PersistenceScrapImageModel> {
        return realm.objects(PersistenceScrapImageModel.self)
    }

    public func deleteScrapImage(byImageID imageID: Int) {
        do {
            try realm.write {
                if let imageToDelete = realm
                    .objects(PersistenceScrapImageModel.self)
                    .filter("imageID == %@", imageID)
                    .first {
                    realm.delete(imageToDelete)
                } else {
                    logger.warning("Image with imageID \(imageID) not found in database.")
                }
            }
        } catch {
            logger.error("Failed to delete image info: \(error.localizedDescription)")
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
