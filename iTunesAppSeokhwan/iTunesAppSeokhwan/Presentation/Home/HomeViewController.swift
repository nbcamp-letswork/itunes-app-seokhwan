//
//  HomeViewController.swift
//  iTunesAppSeokhwan
//
//  Created by youseokhwan on 5/8/25.
//

import UIKit
import RxSwift
import RxCocoa

final class HomeViewController: UIViewController {
    private weak var coordinator: FlowCoordinator?
    private let viewModel: HomeViewModel
    private let disposeBag = DisposeBag()

    private let homeView = HomeView()

    init(viewModel: HomeViewModel, coordinator: FlowCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func loadView() {
        view = homeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        viewModel.action.accept(.viewDidLoad)
    }
}

private extension HomeViewController {
    func configure() {
        setBindings()
    }

    func setBindings() {
        viewModel.state.items
            .asDriver(onErrorJustReturn: [])
            .drive { [weak self] music in
                self?.homeView.updateMusic(with: music)
            }
            .disposed(by: disposeBag)

        viewModel.state.pushToDetail
            .asDriver(onErrorDriveWith: .empty())
            .drive { [weak self] mediaItem in
                self?.coordinator?.pushToDetail(with: mediaItem)
            }
            .disposed(by: disposeBag)

        viewModel.state.errorMessage
            .asDriver(onErrorJustReturn: "")
            .drive { [weak self] message in
                self?.presentErrorAlert(with: message)
            }
            .disposed(by: disposeBag)

        homeView.didTapCell
            .asDriver(onErrorDriveWith: .empty())
            .drive { [weak self] indexPath in
                self?.viewModel.action.accept(.didTapCell(indexPath))
            }
            .disposed(by: disposeBag)
    }
}
