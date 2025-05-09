//
//  HomeCollectionViewLayout.swift
//  iTunesAppSeokhwan
//
//  Created by youseokhwan on 5/9/25.
//

import UIKit

extension HomeView {
    enum HomeSection: Hashable {
        case spring
        case summer
        case autumn
        case winter

        init(sectionIndex: Int) {
            switch sectionIndex {
            case 0:
                self = .spring
            case 1:
                self = .summer
            case 2:
                self = .autumn
            case 3:
                self = .winter
            default:
                fatalError()
            }
        }

        var section: NSCollectionLayoutSection {
            switch self {
            case .spring, .autumn:
                return cardSection
            case .summer, .winter:
                return listSection
            }
        }

        var cardSection: NSCollectionLayoutSection {
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0),
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.9),
                heightDimension: .absolute(266),
            )
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitems: [item],
            )

            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPaging
            section.interGroupSpacing = 12
            section.contentInsets = .init(top: 12, leading: 12, bottom: 12, trailing: 12)

            return section
        }

        var listSection: NSCollectionLayoutSection {
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0 / 3.0),
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.9),
                heightDimension: .absolute(206),
            )
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: groupSize,
                repeatingSubitem: item,
                count: 3,
            )

            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPaging
            section.interGroupSpacing = 12
            section.contentInsets = .init(top: 12, leading: 12, bottom: 12, trailing: 12)

            return section
        }
    }

    struct MusicItem: Hashable {
        let id: Int
        let title: String
        let artist: String
        let albumImagePath: String
    }

    var compositionalLayout: UICollectionViewCompositionalLayout {
        .init { index, _ -> NSCollectionLayoutSection in
            HomeSection(sectionIndex: index).section
        }
    }
}
