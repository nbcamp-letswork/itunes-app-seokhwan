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
            MusicHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: MusicHeader.identifier,
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
            make.top.equalTo(searchBar.snp.bottom).offset(12)
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

        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else {
                return UICollectionReusableView()
            }
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: MusicHeader.identifier,
                for: indexPath,
            ) as? MusicHeader else { return UICollectionReusableView() }

            let section = HomeSection(sectionIndex: indexPath.section)

            switch section {
            case .spring:
                header.update(title: "봄 추천 음악", subtitle: "싱그러운 봄 느낌의 음악 모음")
            case .summer:
                header.update(title: "여름 추천 음악", subtitle: "뜨거운 여름에 어울리는 음악")
            case .autumn:
                header.update(title: "가을 추천 음악", subtitle: "쓸쓸한 감성의 음악 리스트")
            case .winter:
                header.update(title: "겨울 추천 음악", subtitle: "포근한 겨울 감성 음악")
            }

            return header
        }

        var snapshot = NSDiffableDataSourceSnapshot<HomeSection, HomeViewModel.MusicDisplayModel>()
        snapshot.appendSections([.spring, .summer, .autumn, .winter])

        dataSource?.apply(snapshot)
    }
}
