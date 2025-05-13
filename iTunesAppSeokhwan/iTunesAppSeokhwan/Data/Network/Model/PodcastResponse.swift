//
//  PodcastResponse.swift
//  iTunesAppSeokhwan
//
//  Created by youseokhwan on 5/8/25.
//

import Foundation

struct PodcastResultsResponse: Decodable {
    let results: [PodcastResponse]
}

struct PodcastResponse: Decodable {
    let trackID: Int
    let trackName: String
    let artistName: String
    let collectionName: String
    let primaryGenreName: String
    let releaseDate: String
    let trackTimeMillis: Int?
    let artworkURL: String

    enum CodingKeys: String, CodingKey {
        case trackID = "trackId"
        case trackName
        case artistName
        case collectionName
        case primaryGenreName
        case releaseDate
        case trackTimeMillis
        case artworkURL = "artworkUrl600"
    }
}
