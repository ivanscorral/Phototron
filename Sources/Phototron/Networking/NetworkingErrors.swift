//
//  NetworkingErrors.swift
//
//
//  Created by Ivan Sanchez on 14/12/23.
//

import Foundation

enum PhototronNetworkingError: Error {
    case invalidURL
    case illegalHeader(String)
    case urlSessionError(Error)
    case unknownError(String)
    
    case other(code: Int, message: String)
}
