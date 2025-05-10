//
//  MusicCardCell.swift
//  iTunesAppSeokhwan
//
//  Created by youseokhwan on 5/9/25.
//

import UIKit
import SnapKit

final class MusicCardCell: UICollectionViewCell {
    private let albumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .init(systemName: "music.note.list")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "title"
        label.font = .boldSystemFont(ofSize: 24)
        return label
    }()

    private let artistLabel: UILabel = {
        let label = UILabel()
        label.text = "artist"
        label.font = .systemFont(ofSize: 16)
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

    func update(with item: HomeViewModel.MusicDisplayModel) {
//        albumImageView.image = UIImage()
        titleLabel.text = item.title
        artistLabel.text = item.artist
    }
}

private extension MusicCardCell {
    func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
    }

    func setHierarchy() {
        [albumImageView, titleLabel, artistLabel].forEach {
            contentView.addSubview($0)
        }
    }

    func setConstraints() {
        albumImageView.snp.makeConstraints { make in
            make.top.directionalHorizontalEdges.equalToSuperview()
            make.height.equalTo(200) // ISSUE: 높이 198.67로 지정됨
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(albumImageView.snp.bottom).offset(8)
            make.directionalHorizontalEdges.equalToSuperview().inset(12)
            make.height.equalTo(30)
        }

        artistLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.directionalHorizontalEdges.equalToSuperview().inset(12)
            make.height.equalTo(20)
        }
    }
}
