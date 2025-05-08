//
//  HomeView.swift
//  iTunesAppSeokhwan
//
//  Created by youseokhwan on 5/8/25.
//

import UIKit

final class HomeView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}

private extension HomeView {
    func configure() {
        backgroundColor = .background
    }
}
