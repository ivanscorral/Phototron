//
//  CacheManager.swift
//
//
//  Created by Ivan Sanchez on 14/12/23.
//


/// - Responsible for managing the overall caching strategy of the app.
/// - Interacts with `FileHandler` to perform file-based operations like saving and loading cached files.
/// - Utilizes `CachePolicy` to determine the caching rules, like expiration time, size limit, etc.
/// - Communicates with `CacheTracker` to keep track of what is currently cached, including metadata like size, expiration, etc.
/// - Ensures thread-safe operations by using global actor.
/// - Provides methods for adding, retrieving, and removing cached files.
/// - Offers configurability for the cache settings, allowing the user to set the maximum cache size, expiration time, etc.

import Foundation
import Combine

@available(iOS 16.0, *)
public actor CacheManager: GlobalActor {
    public static let shared = CacheManager()

    private let cacheTracker = CacheTracker.shared
    private let fileHandler = FileHandler.shared
    private let networkManager = NetworkManager.shared

    private init() { 
        
    }

    public func getImageData(from url: URL) async throws -> Data {
        print(await getCachedFile(for: url))
        if let cachedFile = await getCachedFile(for: url),
           let data = try? await fileHandler.read(cachedFile) {
            return data
        } else {
            let data = try await downloadAndCache(from: url)
            print("[CacheManager] Cached \(url.lastPathComponent)")
            return data
        }

    }
    
    /// Returns the id of the cached image if it exists, otherwise returns nil
    
    public func getCachedImageId(for url: URL) async -> String? {
        // Query the cache tracker to see if the image is cached
        let (cachedFile, isCacheHit) = await cacheTracker.query(for: url)
        guard let cachedFile = cachedFile,
            isCacheHit else {
            return nil
        }
        return cachedFile.id
    }

    private func getCachedFile(for url: URL) async -> CachedFile? {
        let (cachedFile, isCacheHit) = await cacheTracker.query(for: url)
        return isCacheHit ? cachedFile : nil
    }

    private func downloadAndCache(from url: URL) async throws -> Data {
        let data = try await networkManager.get(url: url.absoluteString)
        print("[CacheManager] Downloaded \(url.lastPathComponent)")
        let file = CachedFile(origin: url)
        print("Downloaded \(file)")
        try await saveAndAddToCache(file, data)
        return data
    }
    
    func purge() async throws {
        try await cacheTracker.purge()
    }

    private func saveAndAddToCache(_ file: CachedFile, _ data: Data) async throws {
        let saveLocation = file.fileLocation
        try await fileHandler.writeFile(at: saveLocation, data: data)
        try await cacheTracker.add(file)
    }
}
