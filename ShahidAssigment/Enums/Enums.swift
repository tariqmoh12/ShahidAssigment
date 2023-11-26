//
//  Enums.swift
//  ShahidAssigment
//
//  Created by Tariq Mohammad on 25/11/2023.
//

import Foundation

enum SignleResult<T> {
    case success(T)
    case failure(Error)
}

enum NetworkingError: Error {
    case invalidResponse
    case serverError
    case invalidContentType
    case emptyData
}

enum URLs: String {
    case baseUrl = "https://api.giphy.com/v2/emoji"
    case imageDetailsBaseUrl = "https://api.giphy.com/v1/gifs/"
}

enum APIKey: String {
    case apiKey = "Gs5pKSXIk95g2px1s75uHxPc4Ic8sf34"
}
