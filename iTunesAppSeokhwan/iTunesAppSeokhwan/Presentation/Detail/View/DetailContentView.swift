//
//  DetailContentView.swift
//  iTunesAppSeokhwan
//
//  Created by youseokhwan on 5/18/25.
//

import UIKit
import SnapKit

final class DetailContentView: UIView {
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 6
        return stackView
    }()

    private let headerView: UILabel = {
        let label = UILabel()
        label.text = "Header"
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()

    private let contentView: UILabel = {
        let label = UILabel()
        label.text = "Content"
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func update(header: String, content: String) {
        headerView.text = header
        contentView.text = content
    }
}

private extension DetailContentView {
    func configure() {
        setHierarchy()
        setConstraints()
    }

    func setHierarchy() {
        [headerView, contentView].forEach {
            stackView.addArrangedSubview($0)
        }
        addSubview(stackView)
    }

    func setConstraints() {
        stackView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.directionalHorizontalEdges.equalToSuperview().inset(24)
        }
    }
}
