//
//  CacheTracker.swift
//
//
//  Created by Ivan Sanchez on 14/12/23.
//


/// - Keeps track of cached items and their metadata.
/// - Stores information like size, expiration time, file location, etc.
/// - Responsible for writing and reading the cache metadata to and from disk.
/// - Uses JSON to store the metadata in a human-readable format.
/// - Provides functionality to add, remove, and retrieve cached items.
/// - Assists `CacheManager` in determining whether an item is cached or not or should be updated


import Foundation
import Combine

@available(iOS 16.0, *)
actor CacheTracker: GlobalActor {
    
    public static let shared = CacheTracker()
    
    let cacheUpdated = PassthroughSubject<Void, Never>()
        
    // In-memory cache metadata dictionary
    private var inMemoryCache: [String: CachedFile] = [:]
    
    private static let cacheMetadataURL = URL.metadataURL
    
    private init() {
        Task {
            await loadMetadataFromDisk()
        }
    }
    
    private func loadMetadataFromDisk() async {
            do {
                let data = try await FileHandler.shared.readFile(at: URL.metadataURL)
                let decoder = JSONDecoder()
                let cachedFiles = try decoder.decode([CachedFile].self, from: data)

                // Check for duplicate keys
                let hasDuplicates = Set(cachedFiles.map { $0.origin.absoluteString }).count != cachedFiles.count
                if hasDuplicates {
                    debugPrint("[CacheTracker] WARN ⚠️: Duplicate keys detected. Purging cache.")
                    await purgeCache()
                } else {
                    inMemoryCache = Dictionary(uniqueKeysWithValues: cachedFiles.map { ($0.origin.absoluteString, $0) })
                }
            } catch {
                debugPrint("[CacheTracker] Error loading cache metadata from disk: \(error). This is normal if it's the first time the app is run.")
            }
        }

    private func purgeCache() async {
        do {
            try await FileHandler.shared.clearAll()
            try await self.purge()
        } catch {
            debugPrint("[CacheTracker] ERROR ⛔️: Error purging cache: \(error)")
        }
    }
    
    public static func getAllCachedItems() async throws -> [CachedFile] {
        guard cacheMetadataURL.fileExists else {
            throw PhototronCacheError.noMetadataFile
        }

        let data = try await FileHandler.shared.readFile(at: cacheMetadataURL)
        let decoder = JSONDecoder()
        return try decoder.decode([CachedFile].self, from: data)
    }

    
    func add(_ cachedFile: CachedFile) async throws {
        inMemoryCache[cachedFile.origin.absoluteString] = cachedFile
        try await writeMetadataToDisk()
        cacheUpdated.send()
    }
    
    func purge() async throws {
        inMemoryCache.removeAll()
        try await writeMetadataToDisk()
    }
    
    private func writeMetadataToDisk() async throws {
        let cachedFilesArray = Array(inMemoryCache.values)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted // Optional, for readability

        do {
            let jsonData = try encoder.encode(cachedFilesArray)
            try await FileHandler.shared.writeFile(at: Self.cacheMetadataURL, data: jsonData)
        } catch {
            debugPrint("[CacheTracker] ERROR ⛔️: Error writing cache metadata to disk: \(error)")
            throw error
        }
    }

    func query(for originURL: URL) async -> (CachedFile?, Bool) {     
        if let cachedFile = inMemoryCache[originURL.absoluteString] {
            debugPrint("[CacheTracker] Cache HIT: .../\(originURL.lastPathComponent)")
            return (cachedFile, true)
        } else {
            debugPrint("[CacheTracker] Cache MISS: .../\(originURL.lastPathComponent)")
            return (nil, false)
        }
    }
    
    
}
