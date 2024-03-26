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
    private let pathComponents: [String]

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
    var httpMethod: RMHttpMethod { .GET }

    // MARK: - Public

    /// Construct request
    /// - Parameters:
    ///   - endpoint: Target endpoint
    ///   - pathComponents: Collection of path components
    ///   - queryParameters: Collection of query parameters
    init(
        endpoint: RMEndpoint,
        httpMethod: RMHttpMethod = .GET,
        pathComponents: [String] = [],
        queryParameters: [URLQueryItem] = [URLQueryItem]()
    ) {
        self.endpoint = endpoint
        self.pathComponents = pathComponents
        self.queryParameters = queryParameters
    }

    convenience init?(url: URL) {
        let string = url.absoluteString

        if !string.contains(Constants.baseUrl) {
            return nil
        }

        let trimmed = string.replacingOccurrences(of: Constants.baseUrl + "/", with: "")
        if trimmed.contains("/") {
            let components = trimmed.components(separatedBy: "/")
            if !components.isEmpty {
                let endpointString = components[0]
                if let rmEndpoint = RMEndpoint(rawValue: endpointString) {
                    self.init(endpoint: rmEndpoint)
                    return
                }
            }
        }

        if trimmed.contains("?") {
            let components = trimmed.components(separatedBy: "?")
            if !components.isEmpty, components.count >= 2 {
                let endpointString = components[0]
                let queryItemsString = components[1]
                let queryItems: [URLQueryItem] = queryItemsString
                    .components(separatedBy: "&")
                    .compactMap {
                        guard $0.contains("=") else { return nil }

                        let parts = $0.components(separatedBy: "=")

                        return URLQueryItem(name: parts[0], value: parts[1])
                    }

                if let rmEndpoint = RMEndpoint(rawValue: endpointString) {
                    self.init(endpoint: rmEndpoint, queryParameters: queryItems)
                    return
                }
            }
        }

        return nil
    }
}

extension RMRequest {
    static let listCharactersRequest = RMRequest(endpoint: .character)
}
