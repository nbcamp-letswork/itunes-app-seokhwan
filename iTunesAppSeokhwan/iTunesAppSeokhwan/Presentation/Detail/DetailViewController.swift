//
//  DetailViewController.swift
//  iTunesAppSeokhwan
//
//  Created by youseokhwan on 5/18/25.
//

import UIKit
import RxSwift
import RxCocoa

final class DetailViewController: UIViewController {
    private let viewModel: DetailViewModel
    private let disposeBag = DisposeBag()

    private let detailView = DetailView()

    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func loadView() {
        view = detailView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        viewModel.action.accept(.viewDidLoad)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
    }
}

private extension DetailViewController {
    func configure() {
        setBindings()
    }

    func setBindings() {
        viewModel.state.item
            .asDriver(onErrorDriveWith: .empty())
            .drive { [weak self] item in
                self?.detailView.update(with: item)
            }
            .disposed(by: disposeBag)

        detailView.didTapCloseButton
            .asDriver(onErrorJustReturn: ())
            .drive { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
}
