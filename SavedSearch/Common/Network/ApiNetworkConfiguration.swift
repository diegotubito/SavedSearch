//
//  ApiNetworkConfiguration.swift
//  SavedSearch
//
//  Created by David Diego Gomez on 05/11/2023.
//


import Foundation

public struct ApiRequestConfiguration {
    public var noTokenNeeded = false
    public var refresingToken = false
    public var path: String = ""
    public var method: Method?
    public var body: Data?
    public var headers: [String: String] = [:]
    public var queryItems: [QueryModel] = []
    public var server: Server = .serverApiV2
    
    public var imageData: Data? = nil
    public var mimeType: MimeType = .png
        
    public enum MimeType : String {
        case png = "image/png"
        case pdf = "application/pdf"
        case jpeg = "image/jpeg"
    }
 
    public struct QueryModel {
        var key: String
        var value: String
    }
    
    public enum Method: String {
        case get = "GET"
        case put = "PUT"
        case post = "POST"
        case delete = "DELETE"
        case patch = "PATCH"
    }
    
    public enum Server: String {
        case serverApiV2
        case mobileGatewayPath
    }
    
    func getHost() -> String {
        #if targetEnvironment(simulator)
            return "http://127.0.0.1:3001"
        #else
            return "https://obscure-ravine-72715.herokuapp.com"
        #endif
    }
    
    public mutating func addCustomHeader(key: String, value: String) {
        headers[key] = value
    }

    public mutating func addQueryItem(key: String, value: String) {
        let newQuery = QueryModel(key: key, value: value)
        queryItems.append(newQuery)
    }

    public mutating func addRequestBody<TRequest> (_ body: TRequest?,
                                          _ keyEncodingStrategy: JSONEncoder.KeyEncodingStrategy = .useDefaultKeys)
    where TRequest: Encodable {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = keyEncodingStrategy
        self.body = try? encoder.encode(body)
    }
    
    public mutating func getUrl() -> URL? {
        guard var urlComponents = URLComponents(string: getHost()) else {
            return nil
        }
        urlComponents.path = path

        urlComponents.queryItems = queryItems.map {
            return URLQueryItem(name: $0.key, value: $0.value)
        }

        urlComponents.percentEncodedQuery = urlComponents
            .percentEncodedQuery?
            .replacingOccurrences(of: "+", with: "%2B")

        return urlComponents.url?.absoluteURL
    }
}


