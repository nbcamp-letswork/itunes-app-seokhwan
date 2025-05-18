//
//  DetailViewModel.swift
//  iTunesAppSeokhwan
//
//  Created by youseokhwan on 5/18/25.
//

import Foundation
import RxSwift
import RxRelay

final class DetailViewModel {
    let action = PublishRelay<Action>()
    let state = State()

    private let mediaItem: MediaItem
    private let disposeBag = DisposeBag()

    init(mediaItem: MediaItem) {
        self.mediaItem = mediaItem
        setBindings()
    }

    private func setBindings() {
        action
            .subscribe(onNext: { [weak self] action in
                switch action {
                case .viewDidLoad:
                    self?.updateDisplayModel()
                }
            })
            .disposed(by: disposeBag)
    }

    private func updateDisplayModel() {
        let item = toDisplayModel(from: mediaItem)
        state.item.accept(item)
    }

    private func toDisplayModel(from entity: MediaItem) -> Item {
        let mediaType: Item.MediaType
        switch mediaItem.mediaType {
        case .music:
            mediaType = .music
        case .movie:
            mediaType = .movie
        case .podcast:
            mediaType = .podcast
        }

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월 d일"
        let releaseDate = formatter.string(from: mediaItem.releaseDate)

        let totalSeconds = mediaItem.runningTime / 1000
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        let runningTime = "\(minutes)분 \(seconds)초"

        return Item(
            title: mediaItem.title,
            mediaType: mediaType,
            artist: mediaItem.artist,
            collection: mediaItem.collection,
            genre: mediaItem.genre,
            releaseDate: releaseDate,
            runningTime: runningTime,
            description: mediaItem.description,
            imagePath: mediaItem.artworkBasePath + "600x600bb.jpg",
        )
    }
}

extension DetailViewModel {
    enum Action {
        case viewDidLoad
    }
    
    struct State {
        let item = BehaviorRelay<Item>(value: Item(
            title: "",
            mediaType: .music,
            artist: "",
            collection: "",
            genre: "",
            releaseDate: "",
            runningTime: "",
            description: "",
            imagePath: "",
        ))
    }

    struct Item {
        enum MediaType {
            case music
            case movie
            case podcast
        }

        let title: String
        let mediaType: MediaType
        let artist: String
        let collection: String
        let genre: String
        let releaseDate: String
        let runningTime: String
        let description: String
        let imagePath: String
    }
}
