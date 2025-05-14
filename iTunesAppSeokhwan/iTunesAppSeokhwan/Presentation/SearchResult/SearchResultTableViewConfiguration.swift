//
//  SearchResultTableViewConfiguration.swift
//  iTunesAppSeokhwan
//
//  Created by youseokhwan on 5/14/25.
//

import UIKit

extension SearchResultView {
    typealias DataSource = UITableViewDiffableDataSource<SearchResultSection, SearchResultItem>
    typealias CellProvider = DataSource.CellProvider
    typealias Snapshot = NSDiffableDataSourceSnapshot<SearchResultSection, SearchResultItem>

    enum MediaType: Hashable {
        case movie
        case podcast

        var cellBackgroundColor: UIColor {
            switch self {
            case .movie:
                return .movieBackground
            case .podcast:
                return .podcastBackground
            }
        }
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

    var cellProvider: CellProvider {
        { tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SearchResultCell.identifier,
                for: indexPath,
            ) as? SearchResultCell else { fatalError() }
            cell.update(with: item)
            return cell
        }
    }
}
