//
//  DataBaseManager.swift
//  ShahidAssigment
//
//  Created by Tariq Mohammad on 25/11/2023.
//

import Foundation
import RealmSwift
import Realm

final class RealmManager {
    
    static let shared = RealmManager()
    private let realm: Realm
    
    private init() {
        do {
            realm = try Realm()
        } catch {
            fatalError("Failed to initialize Realm: \(error.localizedDescription)")
        }
    }
    
    func saveObject<T: Object>(_ object: T, completion: @escaping (SignleResult<Void>) -> Void) {
        do {
            if realm.object(ofType: T.self, forPrimaryKey: object.value(forKey: "id")) == nil {
                try realm.write {
                    realm.add(object)
                    completion(.success(()))
                }
            } else {
                completion(.failure(NSError(domain: "Error with saving data", code: 2, userInfo: [NSLocalizedDescriptionKey: "Object already exists in favorites"])))
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    func deleteObject<T: Object>(_ object: T, completion: @escaping (SignleResult<Void>) -> Void) {
        do {
            if let existingObject = realm.object(ofType: T.self, forPrimaryKey: object.value(forKey: "id")) {
                try realm.write {
                    realm.delete(existingObject)
                    completion(.success(()))
                }
            } else {
                completion(.failure(NSError(domain: "YourAppDomain", code: 1, userInfo: [NSLocalizedDescriptionKey: "Object not found in favorites"])))
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    func getObjects<T: Object>(_ objectType: T.Type) -> Results<T> {
        return realm.objects(objectType)
    }
    
    func removeAllObjectsOfType<T: Object>(_ objectType: T.Type) {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(realm.objects(objectType))
        }
    }
}
