//
//  CachedFile.swift
//
//
//  Created by Ivan Sanchez on 14/12/23.
//

/// - Represents a cached file.
/// - Contains the file data and metadata like size, expiration time, file location, etc.
/// - Conforms to `Codable` to allow for JSON serialization.

import Foundation

public struct CachedFile: Codable {
    let origin: URL
    var expirationDate: Date?
    var lastAccessDate: Date?
    public var fileLocation: URL
    
    

    /// Returns the file name of the cached file, without the extension.
    public var id: String {
        return origin.deletingPathExtension().lastPathComponent
    }
    
    public var realPath: String {
           return fileLocation.path
       }
       
    
    public var isExpired: Bool {
        guard let expirationDate = expirationDate else {
            return false
        }
        
        return expirationDate < Date()
    }
    
    
    init(origin: URL, expirationDate: Date? = nil) {
        self.origin = origin
        self.expirationDate = expirationDate
        self.lastAccessDate = nil
        self.fileLocation = URL.generateRandomCacheURL(withExtension: origin.pathExtension)
    }
    
    enum CodingKeys: String, CodingKey {
        case origin
        case expirationDate
        case lastAccessDate
        case fileLocation
    }
        
}

