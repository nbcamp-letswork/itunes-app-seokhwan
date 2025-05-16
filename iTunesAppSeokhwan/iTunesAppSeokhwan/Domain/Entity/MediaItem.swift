//
//  MediaItem.swift
//  iTunesAppSeokhwan
//
//  Created by youseokhwan on 5/15/25.
//

import Foundation

struct MediaItem {
    enum MediaType {
        case music
        case movie
        case podcast
    }

    let id: Int
    let mediaType: MediaType
    let title: String
    let artist: String
    let collection: String
    let genre: String
    let releaseDate: Date
    let runningTime: Int
    let description: String
    let artworkBasePath: String
}
