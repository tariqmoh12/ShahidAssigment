//
//  NetworkingManager.swift
//  ShahidAssigment
//
//  Created by Tariq Mohammad on 24/11/2023.
//

import Foundation
class NetworkingManager {
    
    static let shared = NetworkingManager()
    
    // MARK: To make sure that one instance will be created
    private init() {
    }
    
    static func fetchData<T: Decodable>(for: T.Type, from url: URL) async throws -> T {
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkingError.invalidResponse
            }
            guard httpResponse.statusCode == 200 else {
                throw NetworkingError.serverError
            }
            
            do {
                let decoder = JSONDecoder()
                return try decoder.decode(T.self, from: data)
            } catch {
                throw error
            }
        } catch {
            throw error
        }
    }
}
