//
//  HomeView.swift
//  iTunesAppSeokhwan
//
//  Created by youseokhwan on 5/8/25.
//

import UIKit
import SnapKit

final class HomeView: UIView {
    private var dataSource: UICollectionViewDiffableDataSource<HomeSection, MusicItem>?

    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "영화, 팟캐스트 검색"
        return searchBar
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: compositionalLayout,
        )
        collectionView.register(
            MusicCardCell.self,
            forCellWithReuseIdentifier: MusicCardCell.identifier,
        )
        collectionView.register(
            MusicListCell.self,
            forCellWithReuseIdentifier: MusicListCell.identifier,
        )
        return collectionView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}

private extension HomeView {
    func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
        setDataSource()
    }

    func setAttributes() {
        backgroundColor = .background
    }

    func setHierarchy() {
        [searchBar, collectionView].forEach {
            addSubview($0)
        }
    }

    func setConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.directionalHorizontalEdges.equalTo(safeAreaLayoutGuide).inset(12)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.directionalHorizontalEdges.equalTo(safeAreaLayoutGuide).inset(12)
            make.bottom.equalToSuperview()
        }
    }

    func setDataSource() {
        dataSource = .init(collectionView: collectionView) { collectionView, indexPath, item in
            let section = HomeSection(sectionIndex: indexPath.section)

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

        var snapshot = NSDiffableDataSourceSnapshot<HomeSection, MusicItem>()
        snapshot.appendSections([.spring, .summer, .autumn, .winter])
        snapshot.appendItems([
            MusicItem(id: 0, title: "Test0", artist: "Test0", albumImagePath: ""),
            MusicItem(id: 1, title: "Test1", artist: "Test1", albumImagePath: ""),
            MusicItem(id: 2, title: "Test2", artist: "Test2", albumImagePath: ""),
            MusicItem(id: 3, title: "Test3", artist: "Test3", albumImagePath: ""),
        ], toSection: .spring)
        snapshot.appendItems([
            MusicItem(id: 4, title: "Test4", artist: "Test4", albumImagePath: ""),
            MusicItem(id: 5, title: "Test5", artist: "Test5", albumImagePath: ""),
            MusicItem(id: 6, title: "Test6", artist: "Test6", albumImagePath: ""),
            MusicItem(id: 7, title: "Test7", artist: "Test7", albumImagePath: ""),
        ], toSection: .summer)
        snapshot.appendItems([
            MusicItem(id: 8, title: "Test8", artist: "Test8", albumImagePath: ""),
            MusicItem(id: 9, title: "Test9", artist: "Test9", albumImagePath: ""),
            MusicItem(id: 10, title: "Test10", artist: "Test10", albumImagePath: ""),
            MusicItem(id: 11, title: "Test11", artist: "Test11", albumImagePath: ""),
        ], toSection: .autumn)
        snapshot.appendItems([
            MusicItem(id: 12, title: "Test12", artist: "Test12", albumImagePath: ""),
            MusicItem(id: 13, title: "Test13", artist: "Test13", albumImagePath: ""),
            MusicItem(id: 14, title: "Test14", artist: "Test14", albumImagePath: ""),
            MusicItem(id: 15, title: "Test15", artist: "Test15", albumImagePath: ""),
        ], toSection: .winter)

        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}
