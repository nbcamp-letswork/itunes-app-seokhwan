//
//  MusicListCell.swift
//  iTunesAppSeokhwan
//
//  Created by youseokhwan on 5/9/25.
//

import UIKit
import SnapKit

final class MusicListCell: UICollectionViewCell {
    private let albumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .init(systemName: "music.note.list")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "title"
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()

    private let artistLabel: UILabel = {
        let label = UILabel()
        label.text = "artist"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemGray
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func update(with item: HomeView.HomeItem) {
        albumImageView.setImage(from: item.albumImagePath)
        titleLabel.text = item.title
        artistLabel.text = item.artist
    }
}

private extension MusicListCell {
    func configure() {
        setHierarchy()
        setConstraints()
    }

    func setHierarchy() {
        [titleLabel, artistLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        [albumImageView, stackView].forEach {
            contentView.addSubview($0)
        }
    }

    func setConstraints() {
        albumImageView.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
            make.size.equalTo(60)
        }

        stackView.snp.makeConstraints { make in
            make.leading.equalTo(albumImageView.snp.trailing).offset(12)
            make.trailing.centerY.equalToSuperview()
        }
    }
}
