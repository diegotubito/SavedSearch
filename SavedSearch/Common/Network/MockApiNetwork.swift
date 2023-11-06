//
//  MockApiNetwork.swift
//  SavedSearch
//
//  Created by David Diego Gomez on 05/11/2023.
//

import Foundation

open class ApiNetworkMock {
    public var mockFileName: String = ""
    var success: Bool = true
    
    public init() {}
    
    var error: APIError?
    
    public func apiCallMocked<T: Decodable>(bundle: Bundle, completionBlock: @escaping (Result<T, APIError>) -> Void) {
        let filenameFromTestingTarget = ProcessInfo.processInfo.environment["FILENAME"] ?? ""
        if !filenameFromTestingTarget.isEmpty {
            mockFileName = filenameFromTestingTarget
        }
        
        let testFail = ProcessInfo.processInfo.arguments.contains("-testFail")
        if testFail {
            success = testFail
        }
        
        guard let data = readLocalFile(bundle: bundle, forName: mockFileName) else {
            completionBlock(.failure(.jsonFileNotFound(filename: mockFileName)))
            return
        }
        
        if !success {
            completionBlock(.failure(.mockFailed))
            return
        }
        
        // If T is of type Data, return the data directly without decoding
        if T.self == Data.self {
            return completionBlock(.success(data as! T))
        }
        
        guard let register = try? JSONDecoder().decode(T.self, from: data) else {
            completionBlock(.failure(.serialization))
            return
        }
        
        completionBlock(.success(register))
    }
    
    private func readLocalFile(bundle: Bundle, forName name: String) -> Data? {
        guard let bundlePath = bundle.path(forResource: name, ofType: "json") else {
            fatalError("file \(name).json doesn't exist")
        }
        
        return try? String(contentsOfFile: bundlePath).data(using: .utf8)
    }
    
}



