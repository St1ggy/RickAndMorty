//
//  RMCharacterDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Dmitrii Bragin on 24.03.2024.
//

import Foundation

final class RMCharacterDetailViewViewModel {
    private let character: RMCharacter

    init(character: RMCharacter) {
        self.character = character
    }

    var title: String {
        character.name.uppercased()
    }
}
