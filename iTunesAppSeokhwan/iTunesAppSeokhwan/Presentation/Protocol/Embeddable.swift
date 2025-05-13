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
}

extension Embeddable {
    func embed(with childViewController: UIViewController) {
        children.forEach {
            $0.willMove(toParent: nil)
            $0.view.removeFromSuperview()
            $0.removeFromParent()
        }

        addChild(childViewController)
        containerView.addSubview(childViewController.view)
        childViewController.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        childViewController.didMove(toParent: self)
    }
}
