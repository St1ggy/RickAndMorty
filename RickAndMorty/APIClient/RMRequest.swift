//
//  RMRequest.swift
//  RickAndMorty
//
//  Created by Dmitrii Bragin on 21.03.2024.
//

import Foundation

/// Object representing a single API call
final class RMRequest {
    /// API Constants
    private enum Constants {
        static let baseUrl = "https://rickandmortyapi.com/api"
    }

    /// Desired endpoint
    private let endpoint: RMEndpoint

    /// Path components for API
    private let pathComponents: Set<String>

    /// Query parameters for API
    private let queryParameters: [URLQueryItem]

    /// Constructed url for the api request in string format
    private var urlString: String {
        var urlString = Constants.baseUrl

        urlString += "/\(endpoint.rawValue)"

        if !pathComponents.isEmpty {
            for pathComponent in pathComponents {
                urlString += "/\(pathComponent)"
            }
        }

        if !queryParameters.isEmpty {
            urlString += "?"

            urlString += queryParameters.compactMap { queryItem in
                guard let value = queryItem.value else { return nil }

                return "\(queryItem.name)=\(value)"
            }.joined(separator: "&")
        }

        return urlString
    }

    /// Computed and constructed API URL
    var url: URL? { URL(string: urlString) }

    /// Desired http method
    var httpMethod: String { "GET" }

    // MARK: - Public

    /// Construct request
    /// - Parameters:
    ///   - endpoint: Target endpoint
    ///   - pathComponents: Collection of path components
    ///   - queryParameters: Collection of query parameters
    init(
        endpoint: RMEndpoint,
        pathComponents: Set<String> = [],
        queryParameters: [URLQueryItem] = [URLQueryItem]()
    ) {
        self.endpoint = endpoint
        self.pathComponents = pathComponents
        self.queryParameters = queryParameters
    }
}
