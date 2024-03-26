//
//  RMCharacterStatus.swift
//  RickAndMorty
//
//  Created by Dmitrii Bragin on 21.03.2024.
//

import Foundation

@frozen enum RMCharacterStatus: String, Codable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown

    var text: String {
        switch self {
            case .alive, .dead:
                return rawValue
            case .unknown:
                return "Unknown"
        }
    }
}
