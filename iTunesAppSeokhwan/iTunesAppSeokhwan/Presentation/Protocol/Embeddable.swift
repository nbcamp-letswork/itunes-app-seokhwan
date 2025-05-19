//
//  Embeddable.swift
//  iTunesAppSeokhwan
//
//  Created by youseokhwan on 5/13/25.
//

import UIKit

protocol Embeddable where Self: UIViewController {
    var containerView: UIView { get }

    func embed(with childViewController: UIViewController)
    func clearSearchText()
}

extension Embeddable {
    func embed(with childViewController: UIViewController) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }

            children.forEach {
                $0.willMove(toParent: nil)
                $0.view.removeFromSuperview()
                $0.removeFromParent()
            }

            addChild(childViewController)

            UIView.transition(
                with: containerView,
                duration: 0.3,
                options: .transitionCrossDissolve,
                animations: { [weak self] in
                    self?.containerView.addSubview(childViewController.view)
                },
                completion: { [weak self] _ in
                    guard let self else { return }
                    childViewController.didMove(toParent: self)
                },
            )

            childViewController.view.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
    }
}
