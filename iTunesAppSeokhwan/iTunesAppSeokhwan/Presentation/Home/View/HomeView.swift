//
//  HomeView.swift
//  iTunesAppSeokhwan
//
//  Created by youseokhwan on 5/8/25.
//

import UIKit
import SnapKit

final class HomeView: UIView {
    private var dataSource: UICollectionViewDiffableDataSource<HomeSection, HomeViewModel.MusicDisplayModel>?

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

    func updateMusics(with musics: [[HomeViewModel.MusicDisplayModel]]) {
        var snapshot = NSDiffableDataSourceSnapshot<HomeSection, HomeViewModel.MusicDisplayModel>()
        let sections: [HomeSection] = [.spring, .summer, .autumn, .winter]

        snapshot.appendSections(sections)
        zip(musics, sections).forEach { music, section in
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

        var snapshot = NSDiffableDataSourceSnapshot<HomeSection, HomeViewModel.MusicDisplayModel>()
        snapshot.appendSections([.spring, .summer, .autumn, .winter])

        dataSource?.apply(snapshot)
    }
}
