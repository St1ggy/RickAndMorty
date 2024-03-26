//
//  GetListResponse.swift
//  RickAndMorty
//
//  Created by Dmitrii Bragin on 22.03.2024.
//

import Foundation

class RMGetListResponse<T: Codable>: Codable {
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }

    let info: Info
    let results: [T]
}
