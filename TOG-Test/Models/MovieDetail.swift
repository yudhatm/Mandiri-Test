//
//  MovieDetail.swift
//  TOG-Test
//
//  Created by Yudha on 17/03/21.
//

import Foundation

struct MovieDetail: Codable {
    let isAdult: Bool
    let backdropPath: String?
    let id: Int
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let popularity: Double
    let posterPath: String?
    let releaseDate: String
    let title: String
    let isVideo: Bool
    let voteAverage: Double
    let voteCount: Int
    let belongToCollection: String?
    let budget: Int
    let homepage: String
    let genres: [Genre]
    let imdb_id: String
    let revenue: Int
    let runtime: Int
    let status: String
    let tagline: String
    
    private enum CodingKeys: String, CodingKey {
        case isAdult = "adult"
        case backdropPath = "backdrop_path"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case isVideo = "video"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case belongToCollection = "belong_to_collection"
        case budget
        case homepage
        case genres
        case imdb_id
        case revenue
        case runtime
        case status
        case tagline
    }
}
