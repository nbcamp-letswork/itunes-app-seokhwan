//
//  HomeView.swift
//  iTunesAppSeokhwan
//
//  Created by youseokhwan on 5/8/25.
//

import UIKit
import SnapKit

final class HomeView: UIView {
    private var dataSource: DataSource?

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
        collectionView.register(MusicHeader.self, MusicCardCell.self, MusicListCell.self)
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func updateMusic(with music: [[HomeItem]]) {
        var snapshot = Snapshot()
        let sections: [HomeSection] = [.spring, .summer, .autumn, .winter]

        snapshot.appendSections(sections)
        zip(music, sections).forEach { music, section in
            snapshot.appendItems(music, toSection: section)
        }

        dataSource?.apply(snapshot)
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
            make.top.equalTo(searchBar.snp.bottom).offset(12)
            make.directionalHorizontalEdges.equalTo(safeAreaLayoutGuide).inset(12)
            make.bottom.equalToSuperview()
        }
    }

    func setDataSource() {
        dataSource = DataSource(collectionView: collectionView, cellProvider: cellProvider)
        dataSource?.supplementaryViewProvider = headerProvider

        var snapshot = Snapshot()
        snapshot.appendSections([.spring, .summer, .autumn, .winter])

        dataSource?.apply(snapshot)
    }
}
