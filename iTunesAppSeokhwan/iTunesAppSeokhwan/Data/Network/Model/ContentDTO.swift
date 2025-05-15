//
//  ContentDTO.swift
//  iTunesAppSeokhwan
//
//  Created by youseokhwan on 5/15/25.
//

import Foundation

struct ContentsDTO: Decodable {
    let results: [ContentDTO]
}

struct ContentDTO: Decodable {
    let trackID: Int
    let trackName: String?
    let artistName: String?
    let collectionName: String?
    let primaryGenreName: String?
    let releaseDate: String?
    let trackTimeMillis: Int?
    let longDescription: String?
    let artworkURL100: String?

    enum CodingKeys: String, CodingKey {
        case trackID = "trackId"
        case trackName
        case artistName
        case collectionName
        case primaryGenreName
        case releaseDate
        case trackTimeMillis
        case longDescription = "longDescription"
        case artworkURL100 = "artworkUrl100"
    }
}
