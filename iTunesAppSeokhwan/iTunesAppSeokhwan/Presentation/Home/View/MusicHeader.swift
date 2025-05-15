//
//  MusicHeader.swift
//  iTunesAppSeokhwan
//
//  Created by youseokhwan on 5/11/25.
//

import UIKit
import SnapKit

final class MusicHeader: UICollectionReusableView {
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Title"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Subtitle"
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 16)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func update(with section: HomeView.Section) {
        titleLabel.text = section.title
        subtitleLabel.text = section.subtitle
    }
}

private extension MusicHeader {
    func configure() {
        setHierarchy()
        setConstraints()
    }

    func setHierarchy() {
        [titleLabel, subtitleLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        addSubview(stackView)
    }

    func setConstraints() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
