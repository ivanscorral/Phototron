//
//  PhototronImageLoader.swift
//
//
//  Created by Ivan Sanchez on 20/12/23.
//

import Foundation
import UIKit

@available(iOS 16.0, *)
actor ImageLoader {
    
    private let url: URL
    
    private var cacheManager: CacheManager = CacheManager.shared
    
    public init(_ url: URL) {
        self.url = url
    }
    
    nonisolated public func loadImage() async throws -> UIImage {
        let cachedImage = try await cacheManager.getImageData(from: url)
        
        guard let image = UIImage(data: cachedImage) else {
            throw PhototronImagingError.ImageLoaderError.invalidImageContent(url: url.absoluteString)
        }
        return image
    }
}
