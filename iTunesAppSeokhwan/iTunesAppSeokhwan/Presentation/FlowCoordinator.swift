//
//  FlowCoordinator.swift
//  iTunesAppSeokhwan
//
//  Created by youseokhwan on 5/8/25.
//

import UIKit

final class FlowCoordinator {
    private let diContainer: DIContainer

    init(diContainer: DIContainer) {
        self.diContainer = diContainer
    }

    func start(completion: @escaping (UIViewController) -> Void) {
        let viewModel = diContainer.makeHomeViewModel()
        let homeViewController = HomeViewController(viewModel: viewModel)

        completion(homeViewController)
    }
}
