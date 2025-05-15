//
//  SearchResultView.swift
//  iTunesAppSeokhwan
//
//  Created by youseokhwan on 5/14/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SearchResultView: UIView {
    private var dataSource: DataSource?
    private let disposeBag = DisposeBag()

    let searchTextTap = PublishRelay<Void>()

    private let searchTextLabel: UILabel = {
        let label = UILabel()
        label.text = "SearchText"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 24)
        label.isUserInteractionEnabled = true
        return label
    }()

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(
            SearchResultCell.self,
            forCellReuseIdentifier: SearchResultCell.identifier,
        )
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 434
        return tableView
    }()

    private let searchTextTapGestureRecognizer = UITapGestureRecognizer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func updateSearchText(with text: String) {
        searchTextLabel.text = text
    }

    func updateItems(with items: [SearchResultViewModel.Item]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)

        dataSource?.apply(snapshot)
    }
}

private extension SearchResultView {
    func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
        setBindings()
        setDataSource()
    }

    func setAttributes() {
        searchTextLabel.addGestureRecognizer(searchTextTapGestureRecognizer)
    }

    func setHierarchy() {
        [searchTextLabel, tableView].forEach {
            addSubview($0)
        }
    }

    func setConstraints() {
        searchTextLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(16)
            make.directionalHorizontalEdges.equalTo(safeAreaLayoutGuide).inset(24)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchTextLabel.snp.bottom).offset(12)
            make.directionalHorizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
    }

    func setBindings() {
        searchTextTapGestureRecognizer.rx.event
            .bind { [weak self] _ in
                self?.searchTextTap.accept(())
            }
            .disposed(by: disposeBag)

    }

    func setDataSource() {
        dataSource = DataSource(tableView: tableView, cellProvider: cellProvider)

        var snapshot = Snapshot()
        snapshot.appendSections([.main])

        dataSource?.apply(snapshot)
    }
}
