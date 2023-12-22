//
//  PhototronImageViewModel.swift
//
//
//  Created by Ivan Sanchez on 20/12/23.
//

import Foundation
import SwiftUI
import Observation

@available(iOS 17.0, *)
@Observable
class PhototronImageViewModel {
    
    private let loader: ImageLoader
    var image: UIImage? = nil
    
    init(_ url: URL) {
        loader = ImageLoader(url)
    }
    
    func loadImage() async throws {
        image = try await loader.loadImage()
    }
}
