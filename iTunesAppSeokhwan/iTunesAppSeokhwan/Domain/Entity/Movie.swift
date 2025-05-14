//
//  Movie.swift
//  iTunesAppSeokhwan
//
//  Created by youseokhwan on 5/14/25.
//

import Foundation

struct Movie: SearchResult {
    let id: Int
    let title: String
    let filmDirector: String
    let seriesTitle: String
    let genre: String
    let releaseDate: Date
    let runningTime: Int
    var posterImagePath: String
    let previewVideoPath: String
}
