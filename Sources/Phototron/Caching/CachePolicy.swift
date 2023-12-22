//
//  CachePolicy.swift
//
//
//  Created by Ivan Sanchez on 14/12/23.
//


/// - Defines the policies for caching, such as default cache duration, maximum cache size, conditions for eviction, etc.
/// - Determines when to cache an item based on factors like network status, item size and user preferences.
/// - Specifies rules for cache eviction, like Least Recently Used (LRU) or time-based eviction.
/// - FUTURE: Allow different cache policies for different types of files (images, videos, etc.)

import Foundation

protocol CachePolicy {
    var maxAgeInSeconds: TimeInterval { get }
    var maxSizeInBytes: Int? { get }
    func shouldCacheItem(withSize size: Int, lastAccessDate: Date, currentDate: Date) -> Bool
}

struct DefaultCachePolicy: CachePolicy {
    var maxAgeInSeconds: TimeInterval
    var maxSizeInBytes: Int?
    
    init(maxAgeInSeconds: TimeInterval = 3600, maxSizeInBytes: Int? = nil) {
        self.maxAgeInSeconds = maxAgeInSeconds
        self.maxSizeInBytes = maxSizeInBytes
    }
    
    func shouldCacheItem(withSize size: Int, lastAccessDate: Date, currentDate: Date) -> Bool {
        let isTimeValid = currentDate.timeIntervalSince(lastAccessDate) <= maxAgeInSeconds
        guard let maxSizeInBytes = maxSizeInBytes else {
            return isTimeValid
        }
        
        return isTimeValid && size <= maxSizeInBytes
    }
}
