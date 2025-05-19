//
//  HomeCollectionViewConfiguration.swift
//  iTunesAppSeokhwan
//
//  Created by youseokhwan on 5/9/25.
//

import UIKit

extension HomeView {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, HomeViewModel.Item>
    typealias CellProvider = DataSource.CellProvider
    typealias HeaderProvider = DataSource.SupplementaryViewProvider
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, HomeViewModel.Item>

    enum Section: Hashable {
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

        var title: String {
            switch self {
            case .spring:
                return "봄"
            case .summer:
                return "여름"
            case .autumn:
                return "가을"
            case .winter:
                return "겨울"
            }
        }

        var subtitle: String {
            switch self {
            case .spring:
                return "싱그러운 봄 느낌의 음악 모음"
            case .summer:
                return "뜨거운 여름에 어울리는 음악"
            case .autumn:
                return "쓸쓸한 감성의 음악 리스트"
            case .winter:
                return "포근한 겨울 감성 음악"
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

        private var cardSection: NSCollectionLayoutSection {
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

            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(50),
            )
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top,
            )

            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPaging
            section.interGroupSpacing = 12
            section.contentInsets = .init(top: 16, leading: 12, bottom: 36, trailing: 12)
            section.boundarySupplementaryItems = [header]

            return section
        }

        private var listSection: NSCollectionLayoutSection {
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

            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(50),
            )
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top,
            )

            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPaging
            section.interGroupSpacing = 12
            section.contentInsets = .init(top: 12, leading: 12, bottom: 24, trailing: 12)
            section.boundarySupplementaryItems = [header]

            return section
        }
    }

    var compositionalLayout: UICollectionViewCompositionalLayout {
        .init { index, _ -> NSCollectionLayoutSection in
            Section(sectionIndex: index).section
        }
    }

    var cellProvider: CellProvider {
        { collectionView, indexPath, item in
            let section = Section(sectionIndex: indexPath.section)

            switch section {
            case .spring, .autumn:
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: MusicCardCell.identifier,
                    for: indexPath,
                ) as? MusicCardCell else { fatalError() }
                cell.update(with: item)
                return cell
            case .summer, .winter:
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: MusicListCell.identifier,
                    for: indexPath,
                ) as? MusicListCell else { fatalError() }
                cell.update(with: item)
                return cell
            }
        }
    }

    var headerProvider: HeaderProvider {
        { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader,
                  let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: MusicHeader.identifier,
                    for: indexPath,
                  ) as? MusicHeader else { fatalError() }
            let section = Section(sectionIndex: indexPath.section)
            header.update(with: section)

            return header
        }
    }
}
