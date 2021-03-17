//
//  UserReview.swift
//  TOG-Test
//
//  Created by Yudha on 17/03/21.
//

import Foundation

struct UserReview: Codable {
    let author: String
    let authorDetail: AuthorDetail
    let content: String
    let createdAt: String
    let updatedAt: String
    let id: String
    let url: String
    
    private enum CodingKeys: String, CodingKey {
        case author
        case authorDetail = "author_details"
        case content
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case id
        case url
    }
}

struct AuthorDetail: Codable {
    let name: String
    let username: String
    let avatar_path: String?
    let rating: Double?
}
