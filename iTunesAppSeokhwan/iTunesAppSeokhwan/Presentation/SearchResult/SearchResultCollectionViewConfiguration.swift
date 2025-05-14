//
//  SearchResultCollectionViewConfiguration.swift
//  iTunesAppSeokhwan
//
//  Created by youseokhwan on 5/14/25.
//

import UIKit

extension SearchResultView {
    enum MediaType: Hashable {
        case movie
        case podcast
    }

    enum SearchResultSection: Hashable {
        case main
    }

    struct SearchResultItem: Hashable {
        let id: Int
        let mediaType: MediaType
        let title: String
        let author: String
        let imagePath: String

        static func == (lhs: SearchResultItem, rhs: SearchResultItem) -> Bool {
            lhs.id == rhs.id && lhs.mediaType == rhs.mediaType
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
            hasher.combine(mediaType)
        }
    }
}
