//
//  Apis.swift
//  ShahidAssigment
//
//  Created by Tariq Mohammad on 24/11/2023.
//

import Foundation
enum Apis {
    case getHomeImages(limit: Int, offset: Int)
    case getImageDetails(id: String)
    
    var url: URL {
        switch self {
        case .getHomeImages(let limit, let offset):
            var components = URLComponents(string: URLs.baseUrl.rawValue)!
            components.queryItems = [
                URLQueryItem(name: "api_key", value: APIKey.apiKey.rawValue),
                URLQueryItem(name: "limit", value: "\(limit)"),
                URLQueryItem(name: "offset", value: "\(offset)"),
            ]
            return APIRequestBuilder.createURL(components: components)
            
        case .getImageDetails(let id):
            var components = URLComponents(string: URLs.imageDetailsBaseUrl.rawValue + "\(id)")!
            components.queryItems = [
                URLQueryItem(name: "api_key", value: APIKey.apiKey.rawValue),
                URLQueryItem(name: "rating", value: "g")
            ]
            return APIRequestBuilder.createURL(components: components)
        }
    }
}

struct APIRequestBuilder {
    
    static func createURL(components: URLComponents) -> URL {
        guard let url = components.url else {
            fatalError("Failed to create URL")
        }
        return url
    }
}

