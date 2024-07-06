//
//  CacheQuery.swift
//  CacheCore
//
//  Created by DOYEON LEE on 7/7/24.
//

import Foundation

public enum CacheQueryError: Error {
    case decodingError
    case queryExecutionError
}

public class CacheQuery {
    private var cache = NSCache<NSString, NSData>()
    private var expiryDates = [NSString: Date]()
    private let cleanUpInterval: TimeInterval = 60
    private var timer: Timer?
    
    public static var shared = CacheQuery()
    
    private init() { // 다양한 Config 받게 해도 좋을듯.
        DispatchQueue.main.async {
            self.startCleanUpTimer()
        }
    }
    
    public struct CacheEntry<Value: Codable>: Codable {
        let value: Value
        let expiryDate: Date
    }
    
    public func makeQuery<Value: Codable>(
        key: CacheQueryKey,
        expiry: TimeInterval, // expiry in seconds
        query: @escaping () async throws -> Value
    ) -> () async throws -> Value {
        return { [weak self] in
            guard let self = self
            else { throw CacheQueryError.queryExecutionError }
            
            let uniqueKey = "\(key.key)"
            print(uniqueKey)
            let nsKey = NSString(string: uniqueKey)
            
            // Check if the cache contains the value and if it is still valid
            if let cachedData = self.cache.object(forKey: nsKey) as NSData? {
                print("캐시 사용!!!!")
                let decoder = JSONDecoder()
                do {
                    let cachedEntry = try decoder.decode(CacheEntry<Value>.self, from: cachedData as Data)
                    if cachedEntry.expiryDate > Date() {
                        return cachedEntry.value
                    } else {
                        // Remove expired entry
                        self.cache.removeObject(forKey: nsKey)
                        self.expiryDates.removeValue(forKey: nsKey)
                    }
                } catch {
                    // If decoding fails, remove the invalid cache entry
                    self.cache.removeObject(forKey: nsKey)
                    self.expiryDates.removeValue(forKey: nsKey)
                    throw CacheQueryError.decodingError
                }
            }
            
            // Execute the query and cache the result
            print("호출호출호출~~~~")
            let result = try await query()
            let expiryDate = Date().addingTimeInterval(TimeInterval(expiry))
            let cacheEntry = CacheEntry(value: result, expiryDate: expiryDate)
            
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(cacheEntry)
            self.cache.setObject(encodedData as NSData, forKey: nsKey)
            self.expiryDates[nsKey] = expiryDate
            
            return result
        }
    }
    
    // Start the clean-up timer
    private func startCleanUpTimer() {
        timer = Timer.scheduledTimer(
            withTimeInterval: cleanUpInterval,
            repeats: true
        ) { [weak self] _ in
            print(#function)
            self?.cleanUpExpiredCache()
        }
    }
    
    // Clean up expired cache entries
    private func cleanUpExpiredCache() {
        let now = Date()
        for (key, expiryDate) in expiryDates where expiryDate <= now {
            cache.removeObject(forKey: key)
            expiryDates.removeValue(forKey: key)
            print("Removed expired cache for key: \(key)")
        }
    }
}
