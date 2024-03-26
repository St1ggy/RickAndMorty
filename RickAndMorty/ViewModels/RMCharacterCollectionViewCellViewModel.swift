//
//  RMCharacterCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Dmitrii Bragin on 24.03.2024.
//

import Foundation

final class RMCharacterCollectionViewCellViewModel: Hashable {
    private let character: RMCharacter

    var characterName: String {
        character.name
    }

    private var characterImageUrl: URL? {
        URL(string: character.image)
    }

    var characterStatusText: String {
        "Status: \(character.status.text)"
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(characterName)
        hasher.combine(characterStatusText)
        hasher.combine(characterImageUrl)
    }

    static func == (
        lhs: RMCharacterCollectionViewCellViewModel,
        rhs: RMCharacterCollectionViewCellViewModel
    ) -> Bool {
        lhs.hashValue == rhs.hashValue
    }

    // MARK: - Init

    init(_ character: RMCharacter) {
        self.character = character
    }

    func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        // TODO: Abstract to Image Manager
        guard let url = characterImageUrl else {
            completion(.failure(URLError(.badURL)))
            return
        }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? URLError(.badServerResponse)))
                return
            }

            completion(.success(data))
        }

        task.resume()
    }
}
