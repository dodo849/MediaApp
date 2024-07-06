//
//  CacheQuery.swift
//  CacheCore
//
//  Created by DOYEON LEE on 7/7/24.
//

import Foundation

public struct CacheQuery {
    private static var cache = NSCache<NSString, NSData>() // static으로 할지 인스턴스화할지 고민
    
    public init() { }
    
    public struct CacheEntry<Value: Codable>: Codable {
        let value: Value
        let expiryDate: Date
    }
    
    public static func makeQuery<Value: Codable>(
        key: CacheQueryKey,
        expiry: Int,// expiry in seconds
        query: @escaping () async throws -> Value
    ) -> () async throws -> Value {
        return {
            let uniqueKey = "\(type(of: key))_\(key)"
            print(uniqueKey)
            let nsKey = NSString(string: uniqueKey)
            
            // Check if the cache contains the value and if it is still valid
            if let cachedData = cache.object(forKey: nsKey) as Data? {
                print("캐시 사용!!!!")
                let decoder = JSONDecoder()
                do {
                    let cachedEntry = try decoder.decode(CacheEntry<Value>.self, from: cachedData)
                    if cachedEntry.expiryDate > Date() {
                        return cachedEntry.value
                    } else {
                        // Remove expired entry
                        cache.removeObject(forKey: nsKey)
                    }
                } catch {
                    // If decoding fails, remove the invalid cache entry
                    cache.removeObject(forKey: nsKey)
                }
            }
            
            // Execute the query and cache the result
            print("호출호출호출~~~~")
            let result = try await query()
            let expiryDate = Date().addingTimeInterval(TimeInterval(expiry))
            let cacheEntry = CacheEntry(value: result, expiryDate: expiryDate)
            
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(cacheEntry)
            cache.setObject(encodedData as NSData, forKey: nsKey)
            
            return result
        }
    }
}
