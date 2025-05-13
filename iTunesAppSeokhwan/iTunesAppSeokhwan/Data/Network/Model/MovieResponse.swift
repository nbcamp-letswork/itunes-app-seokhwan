//
//  MovieResponse.swift
//  iTunesAppSeokhwan
//
//  Created by youseokhwan on 5/8/25.
//

import Foundation

struct MovieResultsResponse: Decodable {
    let results: [MovieResponse]
}

struct MovieResponse: Decodable {
    let trackID: Int
    let trackName: String
    let artistName: String
    let collectionName: String?
    let primaryGenreName: String
    let releaseDate: String
    let trackTimeMillis: Int
    let description: String
    let artworkURL: String
    let previewURL: String

    enum CodingKeys: String, CodingKey {
        case trackID = "trackId"
        case trackName
        case artistName
        case collectionName
        case primaryGenreName
        case releaseDate
        case trackTimeMillis
        case description = "longDescription"
        case artworkURL = "artworkUrl100"
        case previewURL = "previewUrl"
    }
}
