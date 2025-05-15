//
//  SearchResultTableViewConfiguration.swift
//  iTunesAppSeokhwan
//
//  Created by youseokhwan on 5/14/25.
//

import UIKit

extension SearchResultView {
    typealias DataSource = UITableViewDiffableDataSource<Section, SearchResultViewModel.Item>
    typealias CellProvider = DataSource.CellProvider
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, SearchResultViewModel.Item>

    enum Section: Hashable {
        case main
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
