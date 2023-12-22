//
//  PhototronCacheError.swift
//
//
//  Created by Ivan Sanchez on 14/12/23.
//

import Foundation

enum PhototronCacheError: Error {
    case noMetadataFile
    case noCacheDirectory
    case corruptedData(String)
}

public enum FileHandlerError: Error {
    case mkdir(dir: String)
    case fileNotFound(path: String)
    case rmError(path: String)
    case noData
    case illegalFileDestination
}
