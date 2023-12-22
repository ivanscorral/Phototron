//
//  NetworkingErrors.swift
//
//
//  Created by Ivan Sanchez on 19/12/23.
//

import Foundation

public typealias HTTPHeader = (name: String, value: String)



public struct HTTPHeaders {
    private var headers: [String: String] = [:]
    
    init(_ headers: [HTTPHeader] = []) {
        headers.forEach( { _add($0) })
    }
    
    private mutating func _add(_ header: HTTPHeader) {
        headers[header.name] = header.value
    }
    
    public mutating func add(header: HTTPHeader) throws {
        // Ensure the default User-Agent is not overridden.
        guard header.name != "User-Agent" else { throw PhototronNetworkingError.illegalHeader(header.name) }
        headers[header.name] = header.value
    }
    
    public func value(for name: String) -> String? {
        return headers[name]
    }
    
    public var dictionary: [String: String] {
        return headers
    }
}

extension HTTPHeaders: Sequence {
    public func makeIterator() -> Dictionary<String, String>.Iterator {
        return headers.makeIterator()
    }
}
