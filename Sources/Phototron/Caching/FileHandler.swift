//
//  FileHandler.swift
//
//
//  Created by Ivan Sanchez on 14/12/23.
//

import Foundation

/// An actor responsible for managing file system operations related to caching in a phototron environment.
/// It creates, manages cache directories and file paths, and handles data writing and reading operations.
///
/// - Note: This actor requires iOS 13.0 or later.
///
/// Usage:
/// - Use `shared` for accessing a singleton instance of `FileHandler`.
/// - Call `makeDirectory(at:)`, `readFile(at:)`, `writeFile(at:data:)`, or `save(_:)` for respective file operations.
///
@available(iOS 16.0, *)
public actor FileHandler: GlobalActor {
    
    /// The shared singleton instance of `FileHandler`.
    public static let shared = FileHandler()
    
    /// MARK: - Private properties
    
    /// The base component of the phototron directory
    private static let basePathComponent = ".phototron"
    /// The path component for the cache directory
    private static let cachePathComponent = "cache"
    /// The path component for the temporary directory
    private static let tempPathComponent = "temp"
    
    
    /// A FileManager instance for performing file operations
    private var fileManager = FileManager.default
    
    /// Initializes a new instance of `FileHandler`.
    /// Automatically checks and creates the required directories.
    private init() {
        // Check if directories exist
        guard !URL.phototronDirectory.fileExists else {
            // Directories already exist, skip initialization
            return
        }
        // Initialize directories
        Task {
            do {
                try await initializeDirectories()
            } catch {
                print("Error creating directories: \(error)")
            }
        }
    }
    
    /// MARK: - Public methods
    
    
    /// Creates a directory at the specified URL.
    ///
    /// - Parameter url: The URL where the directory will be created.
    /// - Throws: A `FileHandlerError` if the directory cannot be created, containing the path of the directory.
    public func makeDirectory(at url: URL) async throws {
        do {
            try fileManager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        } catch {
            throw FileHandlerError.mkdir(dir: url.path)
        }
    }
    
    /// Reads and returns data from a file at the specified URL.
    ///
    /// - Parameter url: The URL of the file to read.
    /// - Returns: The data read from the file.
    /// - Throws: `FileHandlerError.fileNotFound` if the file doesn't exist or is a directory.
    public func readFile(at url: URL) async throws -> Data {
        
        // Check if file exists and is not a directory
//        guard url.fileExists,
//              !url.isDirectory else {
//            throw FileHandlerError.fileNotFound(path: url.absoluteString)
//        }
        
        let data = try Data(contentsOf: url)
        return data
    }
    
    /// Reads and returns data from a file at the specified URL.
    ///
    /// - Parameter url: The URL of the file to read.
    /// - Returns: The data read from the file.
    /// - Throws: `FileHandlerError.fileNotFound` if the file doesn't exist or is a directory.
    func writeFile(at url: URL, data: Data) async throws {
        do {
            try data.write(to: url)
        } catch {
            throw error
        }
    }
    
    
    /// Saves a `CachedFile` to the file system.
    ///
    /// - Parameter file: The `CachedFile` to be saved.
    /// - Throws: `FileHandlerError.noData` if the file has no data,
    /// or `FileHandlerError.illegalFileDestination` if the file location is not part of the phototron directory.
    public func save(_ file: CachedFile,_ data: Data) async throws {
        
        guard file.fileLocation.isPartOfPhototronDirectory else {
            throw FileHandlerError.illegalFileDestination
        }
        
        
        do {
            try await writeFile(at: file.fileLocation, data: data)
            print("[FileHandler] File saved at \(file.fileLocation.path()), size: \(data.count) bytes")
        } catch {
            throw error
        }
    }
    
    public func read(_ file: CachedFile) async throws -> Data {
        guard file.fileLocation.isPartOfPhototronDirectory else {
            throw FileHandlerError.illegalFileDestination
        }
        
        do {
            let data = try await readFile(at: URL(string: file.realPath)!)
            print("[FileHandler] File read at \(file.fileLocation.path()), size: \(data.count) bytes")
            return data
        } catch {
            throw error
        }
    }
    
    /// Removes all files from the cache directory.
    ///
    /// - Throws: An error if the files cannot be removed.
    public func clearCache() async throws {
        do {
            try fileManager.removeItem(at: URL.cacheDirectory)
            try await makeDirectory(at: URL.cacheDirectory)
            print("[FileHandler] Cache cleared")
        } catch {
            throw FileHandlerError.rmError(path: URL.cacheDirectory.path())
        }
    }
    
    /// Removes all files from the temporary directory.
    ///
    /// - Throws: An error if the files cannot be removed.
    
    public func clearTemp() async throws {
        do {
            try fileManager.removeItem(at: URL.tempDirectory)
            try await makeDirectory(at: URL.tempDirectory)
            print("[FileHandler] Temp cleared")
        } catch {
            throw FileHandlerError.rmError(path: URL.tempDirectory.path())
        }
    }
    
    /// Removes the metadata file.
    ///
    /// - Throws: An error if the file cannot be removed.
    /// - Note: This method should be called along with the `purge()` method in CacheTracker in order to also clear the in-memory cache.
    public func clearMetadata() async throws {
        do {
            // Delete the `metadataURL` file
            try fileManager.removeItem(at: URL.metadataURL)
            print("[FileHandler] Metadata cleared")
        } catch {
            throw FileHandlerError.rmError(path: URL.metadataURL.path())
        }
    }
    
    /// Removes all files from the cache and temporary directories, as well as the metadata file.
    ///
    /// - Throws: An error if the files cannot be removed.
    /// - Note: This method is not thread safe.
    
    public func clearAll() async throws {
        do {
            try await clearCache()
            try await clearTemp()
            try await clearMetadata()
            print("[FileHandler] All cleared")
        } catch {
            throw error
        }
    }
        
    
    // MARK: - Private Methods
    
    /// Initializes the required directories for the phototron environment.
    ///
    /// - Throws: An error if the directories cannot be created.
    private func initializeDirectories() async throws {
        do {
            try await makeDirectory(at: URL.phototronDirectory)
            try await makeDirectory(at: URL.cacheDirectory)
            try await makeDirectory(at: URL.tempDirectory)
            print("[FileHandler] Directories initialized")
        } catch {
            throw error
        }
    }
        
}
