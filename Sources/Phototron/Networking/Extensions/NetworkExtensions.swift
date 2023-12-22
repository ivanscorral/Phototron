//
//  NetworkExtensions.swift
//
//
//  Created by Ivan Sanchez on 14/12/23.
//

import Foundation

@available(iOS 13.0, *)
extension CachedFile {
    // Downloads the file from the given URL and returns the Data when done.
    public func download() async throws -> Data {
        return try await NetworkManager.shared.get(url: origin.absoluteString)
    }
}
