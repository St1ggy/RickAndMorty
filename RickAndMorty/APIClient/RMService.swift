//
//  RMService.swift
//  RickAndMorty
//
//  Created by Dmitrii Bragin on 21.03.2024.
//

import Foundation

/// Primary API service object to get Rick and Morty data
final class RMService {
    /// Shared singleton instance
    static let shared = RMService()

    /// Privatized constructor
    private init() {}
}

// MARK: - Public

extension RMService {
    /// Send Rick and Morty API Call
    /// - Parameters:
    ///   - request: Request instance
    ///   - type: The type of object we expect to get back
    ///   - completion: Callback with data or error
    func execute<T: Codable>(
        _ request: RMRequest,
        expecting type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {}
}
