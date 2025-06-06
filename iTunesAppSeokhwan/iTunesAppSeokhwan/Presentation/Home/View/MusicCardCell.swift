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
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "title"
        label.font = .boldSystemFont(ofSize: 20)
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

    func update(with item: HomeViewModel.Item) {
        albumImageView.setImage(from: item.albumImagePath)
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
        contentView.backgroundColor = .background
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true

        // Cell 그림자 설정
        layer.shadowPath = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: contentView.layer.cornerRadius,
        ).cgPath
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.15
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 8
        layer.masksToBounds = false
    }

    func setHierarchy() {
        [albumImageView, titleLabel, artistLabel].forEach {
            contentView.addSubview($0)
        }
    }

    func setConstraints() {
        albumImageView.snp.makeConstraints { make in
            make.top.directionalHorizontalEdges.equalToSuperview()
            make.height.equalTo(200)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(albumImageView.snp.bottom).offset(6)
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
