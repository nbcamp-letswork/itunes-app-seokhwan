//
//  SearchResultViewController.swift
//  iTunesAppSeokhwan
//
//  Created by youseokhwan on 5/13/25.
//

import UIKit

final class SearchResultViewController: UIViewController {
    private let viewModel: SearchResultViewModel

    private let searchResultView = SearchResultView()

    init(viewModel: SearchResultViewModel) {
        self.viewModel = viewModel
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

    }
}
