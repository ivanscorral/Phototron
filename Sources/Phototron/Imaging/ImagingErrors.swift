//
//  ImagingErrors.swift
//
//
//  Created by Ivan Sanchez on 20/12/23.
//

import Foundation


public enum PhototronImagingError: Error {
    public enum ImageLoaderError: Error {
        case invalidImageContent(url: String)
        case other(Error)
    }
}
