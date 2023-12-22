//
//  URLExtensions.swift
//
//
//  Created by Ivan Sanchez on 14/12/23.
//

import Foundation


/// MARK: Constants


extension URL {
    static let basePathComponent = ".phototron"
    static let cachePathComponent = "cache"
    static let tempPathComponent = "temp"
    
    static let metadataURL: URL = {
        let metadataFileName = "metadata.json"
        return phototronDirectory.appendingPathComponent(metadataFileName)
    }()
}

// MARK: Random File Names


extension URL {
    func withRandomFileName(extension: String) -> URL {
        appendingPathComponent(UUID().uuidString).appendingPathExtension(`extension`)
    }
    
    
    static func generateRandomCacheURL(withExtension fileExtension: String) -> URL {
        // Generate a random name and append the file extension, transforming it into a URL
        let randomFileName = UUID().uuidString
        let randomURL = URL(fileURLWithPath: randomFileName).appendingPathExtension(fileExtension)
        // Append the extension to the random name and generate its cache destination URL
        let destination = URL.cacheDestination(for: randomURL)
        return destination
    }
}

// MARK: Computed Properties

extension URL {
    /// Checks if the file exists at the URL.
    ///
    /// Use this property to verify the existence of a file at the specified URL.
    
    
    static var phototronDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(basePathComponent)
    }
    
    static var cacheDirectory: URL {
        phototronDirectory
            .appendingPathComponent(cachePathComponent)
    }
    
    static var tempDirectory: URL {
        phototronDirectory
            .appendingPathComponent(tempPathComponent)
    }
    
    var fileExists: Bool {
        FileManager.default.fileExists(atPath: path)
    }
    
    /// Determines if the URL is a directory.
    ///
    /// This property helps in identifying if the URL instance points to a directory.
    public var isDirectory: Bool {
        (try? resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory == true
    }
    
    public var isPartOfPhototronDirectory: Bool {
        path.contains(URL.phototronDirectory.path)
    }
}

// MARK: - Cache Specific Extensions

extension URL {
    
    static func cacheDestination(for originalURL : URL) -> URL {
        return cacheDirectory.appendingPathComponent(originalURL.lastPathComponent)
    }
    
    
}
