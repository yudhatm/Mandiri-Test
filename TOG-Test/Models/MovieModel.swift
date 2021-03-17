//
//  MovieModel.swift
//  TOG-Test
//
//  Created by Yudha on 17/03/21.
//

import Foundation

class MovieModel: Codable {
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int
    
    private enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
