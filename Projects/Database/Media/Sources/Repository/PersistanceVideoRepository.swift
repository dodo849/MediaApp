//
//  PersistanceVideoRepository.swift
//  MediaNetwork
//
//  Created by DOYEON LEE on 7/6/24.
//

import RealmSwift

public struct PersistanceVideoRepository {
    private var realm: Realm
    
    public init() {
        do {
            self.realm = try Realm()
        } catch {
            fatalError("Failed to instantiate Realm. Error: \(error.localizedDescription)")
        }
    }
    
    public func saveVideoInfo(_ videoInfo: ScrapVideoModel) {
        do {
            try realm.write {
                realm.add(videoInfo)
            }
        } catch {
            print("Failed to save video info: \(error.localizedDescription)")
        }
    }
    
    public func getAllVideoInfo() -> Results<ScrapVideoModel> {
        return realm.objects(ScrapVideoModel.self)
    }
    
    public func getVideoInfoByCollection(_ collection: String) -> Results<ScrapVideoModel> {
        return realm.objects(ScrapVideoModel.self).filter("collection == %@", collection)
    }
}
