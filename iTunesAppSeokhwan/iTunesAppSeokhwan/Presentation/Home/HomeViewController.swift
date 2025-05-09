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
    private let viewModel: HomeViewModel
    private let disposeBag = DisposeBag()

    private let homeView = HomeView()

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
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

    override func viewWillAppear(_ animated: Bool) {
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = "Music"
    }
}

private extension HomeViewController {
    func configure() {
        setBindings()
    }

    func setBindings() {
        viewModel.state
            .compactMap(\.musics)
            .asDriver(onErrorJustReturn: [])
            .drive { [weak self] musics in
                self?.homeView.updateMusics(with: musics)
            }
            .disposed(by: disposeBag)
    }
}
