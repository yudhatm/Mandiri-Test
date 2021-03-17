//
//  UserReviewModel.swift
//  TOG-Test
//
//  Created by Yudha on 17/03/21.
//

import Foundation

class UserReviewModel: Codable {
    let id: Int
    let page: Int
    let results: [UserReview]
    let totalPages: Int
    let totalResults: Int
    
    private enum CodingKeys: String, CodingKey {
        case id
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
