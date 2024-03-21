//
//  RMCharacterStatus.swift
//  RickAndMorty
//
//  Created by Dmitrii Bragin on 21.03.2024.
//

import Foundation

@frozen enum RMCharacterStatus: String, Codable {
    case alive
    case dead
    case unknown
}
