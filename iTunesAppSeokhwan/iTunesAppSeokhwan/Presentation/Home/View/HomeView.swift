//
//  HomeView.swift
//  iTunesAppSeokhwan
//
//  Created by youseokhwan on 5/8/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class HomeView: UIView {
    private var dataSource: DataSource?
    private let disposeBag = DisposeBag()

    let didTapCell = PublishRelay<IndexPath>()

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

    func updateMusic(with music: [[HomeViewModel.Item]]) {
        var snapshot = Snapshot()
        let sections: [Section] = [.spring, .summer, .autumn, .winter]

        snapshot.appendSections(sections)
        zip(music, sections).forEach { music, section in
            snapshot.appendItems(music, toSection: section)
        }

        dataSource?.apply(snapshot)
    }
}

private extension HomeView {
    func configure() {
        setHierarchy()
        setConstraints()
        setDataSource()
        setBindings()
    }

    func setHierarchy() {
        addSubview(collectionView)
    }

    func setConstraints() {
        collectionView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.directionalHorizontalEdges.equalToSuperview().inset(12)
        }
    }

    func setBindings() {
        collectionView.rx.willBeginDragging
            .bind { [weak self] in
                self?.window?.endEditing(true)
            }
            .disposed(by: disposeBag)

        collectionView.rx.itemSelected
            .bind { [weak self] indexPath in
                self?.didTapCell.accept(indexPath)
            }
            .disposed(by: disposeBag)
    }

    func setDataSource() {
        dataSource = DataSource(collectionView: collectionView, cellProvider: cellProvider)
        dataSource?.supplementaryViewProvider = headerProvider

        var snapshot = Snapshot()
        snapshot.appendSections([.spring, .summer, .autumn, .winter])

        dataSource?.apply(snapshot)
    }
}
