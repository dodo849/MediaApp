//
//  CacheQueryKey.swift
//  CacheCore
//
//  Created by DOYEON LEE on 7/7/24.
//

import Foundation

public protocol CacheQueryKey {
    var key: String { get }
}

public extension CacheQueryKey {
    var key: String {
        return "\(type(of: self))_\(self)"
    }
}
