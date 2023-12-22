//
//  PhototronImage.swift
//
//
//  Created by Ivan Sanchez on 20/12/23.
//

import Foundation
import SwiftUI

@available(iOS 17.0, *)
public struct PhototronImage: View {
    
    public var url: URL
    
    private let viewModel: PhototronImageViewModel
    
    public init(urlString: String) {
        self.url = URL(string: urlString)!
        self.viewModel = PhototronImageViewModel(url)
    }
    
    public init(url: URL) {
        self.url = url
        self.viewModel = PhototronImageViewModel(url)
    }
    
    
    public func load() async  {
        do {
            try await viewModel.loadImage()
        } catch {
            print("[Phototron] Error loading image: \(error)")
        }
    }
    
    public var body: some View {
        Group {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
            } else {
                ProgressView()
                
            }
        }
        .task {
            await load()
        }
    }
}
