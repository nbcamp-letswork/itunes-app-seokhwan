//
//  SceneDelegate.swift
//  iTunesAppSeokhwan
//
//  Created by youseokhwan on 5/8/25.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private let diContainer = DIContainer()
    private var flowCoordinator: FlowCoordinator?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions,
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.backgroundColor = .background

        flowCoordinator = FlowCoordinator(diContainer: diContainer)
        flowCoordinator?.start { [weak self] rootViewController in
            self?.window?.rootViewController = rootViewController
            self?.window?.makeKeyAndVisible()
        }
    }
}
