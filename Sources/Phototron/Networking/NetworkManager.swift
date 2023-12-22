//
//  NativeNetworkManager.swift
//
//
//  Created by Ivan Sanchez on 20/12/23.
//


/// Reimplementation of the NetworkManager actor using the native URLSession API and the custom HTTPHeader(s) type.

import Foundation

public typealias Parameters = [String: Any]

@available(iOS 13.0, *)
actor NetworkManager: GlobalActor {
    static let shared = NetworkManager()
    
    private init() {}
    
    private let urlSession = URLSession.shared
    private var maxWaitTime = 10.0
    
    private static let userAgent: HTTPHeader = ("User-Agent", "Phototron/1.0")
    
    private var additionalHeaders: HTTPHeaders = HTTPHeaders([userAgent])
    
    /// Provides the combined headers, including the default User-Agent.
    public var httpHeaders: HTTPHeaders {
        return additionalHeaders
    }
    
    /// Adds new headers to the network manager, ensuring the default User-Agent is not overridden.
    /// - Throws: `PhototronNetworkingError.illegalHeader` if any header is illegal.
    public func addHeaders(_ newHeaders: HTTPHeaders) throws {
        for header in newHeaders {
            try additionalHeaders.add(header: (name: header.key, value: header.value))
        }
    }
    
    /// Performs a GET request to the specified URL.
    ///
    /// - Parameters:
    ///  - url: The URL to perform the request to.
    ///  - parameters: Optional parameters to be included in the request.
    ///
    ///  - Returns: The response data.
    ///  - Throws: `PhototronNetworkingError.invalidURL` if the URL is invalid.
    
    func get(url: String, parameters: Parameters? = nil) async throws -> Data {
          guard let url = URL(string: url) else {
              throw PhototronNetworkingError.invalidURL
          }

          var request = URLRequest(url: url)
          request.httpMethod = "GET"
          request.allHTTPHeaderFields = httpHeaders.dictionary
          request.timeoutInterval = maxWaitTime

          if let parameters = parameters {
              request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
          }

          do {
              let (data, _) = try await urlSession.data(for: request)
              return data
          } catch {
              // Handle or rethrow URLSession-specific errors
              throw PhototronNetworkingError.urlSessionError(error)
          }
      }
}
