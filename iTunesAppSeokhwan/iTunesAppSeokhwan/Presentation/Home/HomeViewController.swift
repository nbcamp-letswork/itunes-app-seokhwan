//
//  HomeViewController.swift
//  iTunesAppSeokhwan
//
//  Created by youseokhwan on 5/8/25.
//

import UIKit

final class HomeViewController: UIViewController {
    private let viewModel: HomeViewModel

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
}
