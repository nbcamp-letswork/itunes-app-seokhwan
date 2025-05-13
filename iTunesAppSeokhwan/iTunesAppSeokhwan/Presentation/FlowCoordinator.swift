//
//  FlowCoordinator.swift
//  iTunesAppSeokhwan
//
//  Created by youseokhwan on 5/8/25.
//

import UIKit

final class FlowCoordinator {
    enum ViewType {
        case home
        case searchResult(String)
    }

    private let diContainer: DIContainer

    init(diContainer: DIContainer) {
        self.diContainer = diContainer
    }

    func start(completion: @escaping (UIViewController) -> Void) {
        let viewController = MainViewController(coordinator: self)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.prefersLargeTitles = true

        completion(navigationController)
    }

    func switchTo(_ viewType: ViewType, in parent: Embeddable) {
        let childViewController: UIViewController

        switch viewType {
        case .home:
            let viewModel = diContainer.makeHomeViewModel()
            childViewController = HomeViewController(viewModel: viewModel)
        case .searchResult(let searchText):
            let viewModel = diContainer.makeSearchResultViewModel(searchText: searchText)
            childViewController = SearchResultViewController(viewModel: viewModel)
        }

        parent.embed(with: childViewController)
    }
}
