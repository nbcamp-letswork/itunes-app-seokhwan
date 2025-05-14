//
//  Podcast.swift
//  iTunesAppSeokhwan
//
//  Created by youseokhwan on 5/14/25.
//

import Foundation

struct Podcast: SearchResult {
    let id: Int
    let title: String
    let creator: String
    let seriesTitle: String
    let genre: String
    let releaseDate: Date
    let runningTime: Int
    let posterImagePath: String
}
