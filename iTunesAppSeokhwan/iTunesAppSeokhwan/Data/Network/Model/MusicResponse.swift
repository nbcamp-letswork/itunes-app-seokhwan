//
//  MusicResponse.swift
//  iTunesAppSeokhwan
//
//  Created by youseokhwan on 5/8/25.
//

import Foundation

struct MusicResultsResponse: Decodable {
    let results: [MusicResponse]
}

struct MusicResponse: Decodable {
    let trackID: Int
    let trackName: String
    let artistName: String
    let collectionName: String
    let primaryGenreName: String
    let releaseDate: String
    let trackTimeMillis: Int
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
        case artworkURL = "artworkUrl100"
        case previewURL = "previewUrl"
    }
}
