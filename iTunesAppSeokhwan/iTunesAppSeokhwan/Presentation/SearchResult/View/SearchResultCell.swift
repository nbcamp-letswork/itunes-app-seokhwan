//
//  SearchResultCell.swift
//  iTunesAppSeokhwan
//
//  Created by youseokhwan on 5/14/25.
//

import UIKit
import SnapKit

final class SearchResultCell: UITableViewCell {
    private let containerView = UIView()

    private let authorLabel: UILabel = {
        let label = UILabel()
        label.text = "artist"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .systemGray
        return label
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "title"
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()

    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .init(systemName: "photo")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func update(with item: SearchResultView.SearchResultItem) {
        containerView.backgroundColor = item.mediaType.cellBackgroundColor
        authorLabel.text = item.author
        titleLabel.text = item.title
        posterImageView.setImage(from: item.imagePath)
    }
}

private extension SearchResultCell {
    func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        selectionStyle = .none
        backgroundColor = .clear

        containerView.layer.cornerRadius = 8
        containerView.clipsToBounds = true

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.15
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 8
        layer.masksToBounds = false
    }

    func setHierarchy() {
        [authorLabel, titleLabel, posterImageView].forEach {
            containerView.addSubview($0)
        }
        contentView.addSubview(containerView)
    }

    func setConstraints() {
        containerView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(16)
            make.directionalHorizontalEdges.equalToSuperview().inset(16)
        }

        authorLabel.snp.makeConstraints { make in
            make.top.directionalHorizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(20)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(authorLabel.snp.bottom)
            make.directionalHorizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(30)
        }

        posterImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.directionalHorizontalEdges.equalToSuperview()
            make.height.equalTo(300)
            make.bottom.equalToSuperview().inset(24)
        }
    }
}
