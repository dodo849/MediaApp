//
//  PersistenceVideoRepository.swift
//  MediaNetwork
//
//  Created by DOYEON LEE on 7/6/24.
//

import OSLog

import RealmSwift
import Dependencies

public struct PersistenceVideoRepository {
    private let logger = Logger(
        subsystem: Bundle.module.bundleIdentifier!,
        category: "PersistenceVideoRepository"
    )
    private var realm: Realm
    
    public init() {
        do {
            self.realm = try Realm()
        } catch {
            fatalError("Failed to instantiate Realm. Error: \(error.localizedDescription)")
        }
    }
    
    public func saveScrapVideo(_ model: PersistenceScrapVideoModel) {
        do {
            try realm.write {
                realm.add(model)
            }
        } catch {
            print("Failed to save video info: \(error.localizedDescription)")
        }
    }
    
    public func getAllScrapVideo() -> Results<PersistenceScrapVideoModel> {
        return realm.objects(PersistenceScrapVideoModel.self)
    }
    
    public func deleteScrapVideo(byvideoID videoID: Int) {
        do {
            try realm.write {
                if let videoToDelete = realm
                    .objects(PersistenceScrapImageModel.self)
                    .filter("videoID == %@", videoID)
                    .first {
                    realm.delete(videoToDelete)
                } else {
                    logger.warning("Video with videoID \(videoID) not found in database.")
                }
            }
        } catch {
            logger.error("Failed to delete video info: \(error.localizedDescription)")
        }
    }
}

// MARK: - Dependency
private enum PersistenceVideoRepositoryKey: DependencyKey {
    static let liveValue: PersistenceVideoRepository = PersistenceVideoRepository()
}

public extension DependencyValues {
  var persistenceVideoRepository: PersistenceVideoRepository {
    get { self[PersistenceVideoRepositoryKey.self] }
    set { self[PersistenceVideoRepositoryKey.self] = newValue }
  }
}
