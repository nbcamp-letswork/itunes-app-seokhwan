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

final class MainViewController: UIViewController {
    private weak var coordinator: FlowCoordinator?
    private let disposeBag = DisposeBag()

    private let searchController: UISearchController = {
        let controller = UISearchController()
        controller.searchBar.placeholder = "영화, 팟캐스트 검색"
        return controller
    }()

    private let containerView = UIView()

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
        coordinator?.switchTo(.home) { [weak self] viewController in
            self?.embed(with: viewController)
        }
    }

    private func embed(with childViewController: UIViewController) {
        children.forEach {
            $0.willMove(toParent: nil)
            $0.view.removeFromSuperview()
            $0.removeFromParent()
        }

        addChild(childViewController)
        containerView.addSubview(childViewController.view)

        childViewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        childViewController.didMove(toParent: self)
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
        navigationItem.largeTitleDisplayMode = .always
        title = "Music"
    }

    func setHierarchy() {
        view.addSubview(containerView)
    }

    func setConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    func setBindings() {
        searchController.searchBar.rx.searchButtonClicked
            .withLatestFrom(searchController.searchBar.rx.text.orEmpty)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .subscribe(onNext: { [weak self] text in
                self?.coordinator?.switchTo(.searchResult(text)) { [weak self] viewController in
                    self?.embed(with: viewController)
                }
            })
            .disposed(by: disposeBag)

        searchController.searchBar.rx.cancelButtonClicked
            .subscribe(onNext: { [weak self] in
                self?.coordinator?.switchTo(.home) { [weak self] viewController in
                    self?.embed(with: viewController)
                }
            })
            .disposed(by: disposeBag)
    }
}
