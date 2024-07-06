//
//  PersistanceImageRepository.swift
//  MediaNetwork
//
//  Created by DOYEON LEE on 7/6/24.
//

import RealmSwift

public class PersistanceImageRepository {
    private var realm: Realm
    
    public init() {
        do {
            self.realm = try Realm()
        } catch {
            fatalError("Failed to instantiate Realm. Error: \(error.localizedDescription)")
        }
    }
    
    public func saveScrapImage(_ imageInfo: ScrapImageModel) {
        do {
            try realm.write {
                realm.add(imageInfo)
            }
        } catch {
            print("Failed to save image info: \(error.localizedDescription)")
        }
    }
    
    public  func getAllScrapImage() -> Results<ScrapImageModel> {
        return realm.objects(ScrapImageModel.self)
    }
    
    public func getScrapImageByCollection(_ collection: String) -> Results<ScrapImageModel> {
        return realm.objects(ScrapImageModel.self).filter("collection == %@", collection)
    }
}
