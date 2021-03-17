//
//  URLs.swift
//  TOG-Test
//
//  Created by Yudha on 16/03/21.
//

import Foundation

struct URLs {
    static let baseURL = "https://api.themoviedb.org/3/"
    static let imageBaseURL = "https://image.tmdb.org/t/p/"
    
    struct EndPoint {
        static let genreList = "genre/movie/list"
        static let discoverMovie = "discover/movie"
        static let movie = "movie/"
    }
    
    struct PosterSizes {
        static let w92 = "w92"
        static let w154 = "w154"
    }
}

struct API_KEY {
    static let apiKey = "9e26b2ace416879208fb9688f36f0ca9"
}
