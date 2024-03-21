//
//  RMCharacter.swift
//  RickAndMorty
//
//  Created by Dmitrii Bragin on 20.03.2024.
//

import Foundation


struct RMCharacter: Codable {
    let id: Int
    let name: String
    let status: RMCharacterStatus
    let species: String
    let type: String
    let gender: String
    let origin: RMSingleLocation
    let location: RMSingleLocation
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

//    {
//        "id": 2,
//        "name": "Morty Smith",
//        "status": "Alive",
//        "species": "Human",
//        "type": "",
//        "gender": "Male",
//        "origin": {
//            "name": "Earth",
//            "url": "https://rickandmortyapi.com/api/location/1"
//        },
//        "location": {
//            "name": "Earth",
//            "url": "https://rickandmortyapi.com/api/location/20"
//        },
//        "image": "https://rickandmortyapi.com/api/character/avatar/2.jpeg",
//        "episode": [
//            "https://rickandmortyapi.com/api/episode/1",
//            "https://rickandmortyapi.com/api/episode/2",
//            // ...
//        ],
//        "url": "https://rickandmortyapi.com/api/character/2",
//        "created": "2017-11-04T18:50:21.651Z"
//    }
