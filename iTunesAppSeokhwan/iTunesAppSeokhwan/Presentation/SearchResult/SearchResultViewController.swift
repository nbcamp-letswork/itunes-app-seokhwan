//
//  SearchResultViewController.swift
//  iTunesAppSeokhwan
//
//  Created by youseokhwan on 5/13/25.
//

import UIKit
import RxSwift
import RxCocoa

final class SearchResultViewController: UIViewController {
    private weak var coordinator: FlowCoordinator?
    private let viewModel: SearchResultViewModel
    private let disposeBag = DisposeBag()

    private let searchResultView = SearchResultView()

    init(viewModel: SearchResultViewModel, coordinator: FlowCoordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func loadView() {
        view = searchResultView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        viewModel.action.accept(.viewDidLoad)
    }
}

private extension SearchResultViewController {
    func configure() {
        setBindings()
    }

    func setBindings() {
        viewModel.state.searchText
            .asDriver(onErrorJustReturn: "")
            .drive { [weak self] text in
                self?.searchResultView.updateSearchText(with: text)
            }
            .disposed(by: disposeBag)

        viewModel.state.items
            .asDriver(onErrorJustReturn: [])
            .drive { [weak self] items in
                self?.searchResultView.updateItems(with: items)
            }
            .disposed(by: disposeBag)

        searchResultView.searchTextTap
            .asDriver(onErrorJustReturn: ())
            .drive { [weak self] _ in
                guard let self,
                      let parent = parent as? Embeddable else { return }
                parent.clearSearchText()
                self.coordinator?.switchTo(.home, in: parent)
            }
            .disposed(by: disposeBag)
    }
}
