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

    func switchTo(_ viewType: ViewType, completion: @escaping (UIViewController) -> Void) {
        switch viewType {
        case .home:
            let homeViewModel = diContainer.makeHomeViewModel()
            let homeViewController = HomeViewController(viewModel: homeViewModel)

            completion(homeViewController)
        case .searchResult(let searchText):
            let searchResultViewModel = diContainer.makeSearchResultViewModel(searchText: searchText)
            let searchResultViewController = SearchResultViewController(viewModel: searchResultViewModel)

            completion(searchResultViewController)
        }
    }
}
