//
//  GenreModel.swift
//  TOG-Test
//
//  Created by Yudha on 16/03/21.
//

import Foundation

class GenreModel: Codable {
    let genres: [Genre]
    
    private enum CodingKeys: String, CodingKey {
        case genres = "genres"
    }
}
