//
//  PersistenceVideoRepository.swift
//  MediaNetwork
//
//  Created by DOYEON LEE on 7/6/24.
//

import OSLog

import RealmSwift
import Dependencies

public class PersistenceVideoRepository {
    private let realmThreadLabel = "com.realm.video"
    private let logger = Logger(
        subsystem: Bundle.module.bundleIdentifier!,
        category: "PersistenceVideoRepository"
    )
    
    public init() { }
    
    public func saveScrapVideo(_ model: PersistenceScrapVideoModel) {
        DispatchQueue(label: realmThreadLabel).async {
            autoreleasepool {
                do {
                    let realm = try Realm()
                    try realm.write {
                        realm.add(model)
                    }
                } catch {
                    self.logger.error("Failed to save video info: \(error.localizedDescription)")
                }
            }
        }
    }
    
    public func getAllScrapVideo() async throws -> [PersistenceScrapVideoModel] {
        try await withCheckedThrowingContinuation { continuation in
            DispatchQueue(label: realmThreadLabel).async {
                autoreleasepool {
                    do {
                        let realm = try Realm().freeze() // Read only
                        let results = realm.objects(PersistenceScrapVideoModel.self)
                        continuation.resume(returning: Array(results))
                    } catch {
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }

    public func deleteScrapVideo(byVideoID videoID: String) {
        DispatchQueue(label: realmThreadLabel).async { [weak self] in
            autoreleasepool {
                guard let self = self else { return }
                do {
                    let realm = try Realm()
                    try realm.write {
                        if let videoToDelete = realm
                            .objects(PersistenceScrapVideoModel.self)
                            .filter("videoID == %@", videoID)
                            .first {
                            realm.delete(videoToDelete)
                        } else {
                            self.logger.warning("Video with videoID \(videoID) not found in database.")
                        }
                    }
                } catch {
                    self.logger.error("Failed to delete video info: \(error.localizedDescription)")
                }
            }
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
