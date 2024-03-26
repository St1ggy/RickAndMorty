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
    enum ServiceError: Error {
        case failedToCreateRequest
        case failedToGetData
    }

    /// Send Rick and Morty API Call
    /// - Parameters:
    ///   - request: Request instance
    ///   - type: The type of object we expect to get back
    ///   - completion: Callback with data or error
    func execute<T: Codable>(
        _ request: RMRequest,
        expecting type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        guard let urlRequest = self.request(from: request) else {
            completion(.failure(ServiceError.failedToCreateRequest))
            return
        }

        let task = URLSession.shared.dataTask(with: urlRequest) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? ServiceError.failedToGetData))
                return
            }

            do {
                let result = try JSONDecoder().decode(type.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
}

// MARK: - Private

extension RMService {
    /// Create URLRequest from RMRequest
    /// - Parameter fromRequest: Request instance
    /// - Returns: Created URLRequest instance
    func request(from fromRequest: RMRequest) -> URLRequest? {
        guard let url = fromRequest.url else { return nil }

        var request = URLRequest(url: url)
        request.httpMethod = fromRequest.httpMethod.rawValue
//        request.allHTTPHeaderFields = fromRequest.headers

        return request
    }
}
