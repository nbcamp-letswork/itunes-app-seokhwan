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
    private var navigationController: UINavigationController?

    init(diContainer: DIContainer) {
        self.diContainer = diContainer
    }

    func start(completion: @escaping (UIViewController) -> Void) {
        let viewController = MainViewController(coordinator: self)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.prefersLargeTitles = true
        self.navigationController = navigationController

        completion(navigationController)
    }

    func switchTo(_ viewType: ViewType, in parent: Embeddable) {
        let childViewController: UIViewController

        switch viewType {
        case .home:
            let viewModel = diContainer.makeHomeViewModel()
            childViewController = HomeViewController(
                viewModel: viewModel,
                coordinator: self,
            )
        case .searchResult(let searchText):
            let viewModel = diContainer.makeSearchResultViewModel(searchText: searchText)
            childViewController = SearchResultViewController(
                viewModel: viewModel,
                coordinator: self,
            )
        }

        parent.embed(with: childViewController)
    }

    func pushToDetail(with mediaItem: MediaItem) {
        let viewModel = diContainer.makeDetailViewModel(mediaItem: mediaItem)
        let viewController = DetailViewController(viewModel: viewModel)

        navigationController?.pushViewController(viewController, animated: true)
    }
}
