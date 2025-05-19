//
//  MainViewController.swift
//  iTunesAppSeokhwan
//
//  Created by youseokhwan on 5/12/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class MainViewController: UIViewController, Embeddable {
    private weak var coordinator: FlowCoordinator?
    private let disposeBag = DisposeBag()

    private let searchController: UISearchController = {
        let controller = UISearchController()
        controller.searchBar.placeholder = "영화, 팟캐스트 검색"
        return controller
    }()

    let containerView = UIView()

    init(coordinator: FlowCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        coordinator?.switchTo(.home, in: self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .always
    }

    func clearSearchText() {
        searchController.searchBar.text = ""
        searchController.isActive = false
    }
}

private extension MainViewController {
    func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
        setBindings()
    }

    func setAttributes() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Music"
    }

    func setHierarchy() {
        view.addSubview(containerView)
    }

    func setConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func setBindings() {
        searchController.searchBar.rx.searchButtonClicked
            .withLatestFrom(searchController.searchBar.rx.text.orEmpty)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .subscribe(onNext: { [weak self] text in
                guard let self else { return }
                coordinator?.switchTo(.searchResult(text), in: self)
            })
            .disposed(by: disposeBag)

        searchController.searchBar.rx.cancelButtonClicked
            .subscribe(onNext: { [weak self] in
                guard let self else { return }

                if children.first is HomeViewController {
                    clearSearchText()
                } else {
                    coordinator?.switchTo(.home, in: self)
                }
            })
            .disposed(by: disposeBag)
    }
}
