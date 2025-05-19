//
//  DetailView.swift
//  iTunesAppSeokhwan
//
//  Created by youseokhwan on 5/18/25.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class DetailView: UIView {
    private let disposeBag = DisposeBag()

    let didTapCloseButton = PublishRelay<Void>()

    private let scrollView = UIScrollView()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 24
        return stackView
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let titleContentView = DetailContentView()

    private let artistContentView = DetailContentView()

    private let collectionContentView = DetailContentView()

    private let genreContentView = DetailContentView()

    private let releaseDateContentView = DetailContentView()

    private let runningTimeContentView = DetailContentView()

    private let descriptionContentView = DetailContentView()

    private let closeButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "xmark.circle.fill")
        config.baseForegroundColor = .systemGray
        let button = UIButton(configuration: config)
        button.layer.cornerRadius = 22
        button.clipsToBounds = true
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func update(with item: DetailViewModel.Item) {
        imageView.setImage(from: item.imagePath)
        titleContentView.update(header: "제목", content: item.title)
        artistContentView.update(
            header: item.mediaType == .movie ? "영화 감독" : "아티스트",
            content: item.artist,
        )
        collectionContentView.update(
            header: item.mediaType == .music ? "앨범" : "시리즈",
            content: item.collection,
        )
        genreContentView.update(header: "장르", content: item.genre)
        releaseDateContentView.update(header: "출시일", content: item.releaseDate)
        runningTimeContentView.update(header: "러닝타임", content: item.runningTime)
        descriptionContentView.update(header: "설명", content: item.description)
    }

    func updateDescriptionViewIsHidden(_ isHidden: Bool) {
        descriptionContentView.isHidden = isHidden
    }
}

private extension DetailView {
    func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
        setBindings()
    }

    func setAttributes() {
        backgroundColor = .background
    }

    func setHierarchy() {
        [
            imageView,
            titleContentView,
            artistContentView,
            collectionContentView,
            genreContentView,
            releaseDateContentView,
            runningTimeContentView,
            descriptionContentView,
        ].forEach {
            stackView.addArrangedSubview($0)
        }
        scrollView.addSubview(stackView)
        [scrollView, closeButton].forEach {
            addSubview($0)
        }
    }

    func setConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        stackView.snp.makeConstraints { make in
            make.edges.width.equalToSuperview()
        }

        imageView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(imageView.snp.width)
        }

        closeButton.snp.makeConstraints { make in
            make.top.trailing.equalTo(safeAreaLayoutGuide).inset(16)
            make.size.equalTo(44)
        }
    }

    func setBindings() {
        closeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.didTapCloseButton.accept(())
            })
            .disposed(by: disposeBag)
    }
}
