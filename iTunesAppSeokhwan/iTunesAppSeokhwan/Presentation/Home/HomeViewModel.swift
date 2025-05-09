//
//  HomeViewModel.swift
//  iTunesAppSeokhwan
//
//  Created by youseokhwan on 5/8/25.
//

import Foundation
import RxSwift
import RxRelay

final class HomeViewModel {
    private let repository: MusicRepository

    private let musics = BehaviorRelay<[[Music]]>(value: [])
    private let disposeBag = DisposeBag()

    let action = PublishRelay<Action>()
    let state = BehaviorRelay<State>(value: State())

    init(repository: MusicRepository) {
        self.repository = repository
        setBindings()
    }

    private func setBindings() {
        action
            .subscribe(onNext: { [weak self] action in
                switch action {
                case .viewDidLoad:
                    self?.fetchMusics()
                }
            })
            .disposed(by: disposeBag)

        musics
            .map {
                $0.map { $0.enumerated().map { (index, element) in
                    /*
                     spring(0), autumn(2)은 OriginalImage 사용
                     summer(1), winter(3)는 ThumbnailImage 사용
                     */
                    MusicDisplayModel(from: element, usesOriginalImage: index % 2 == 0)
                } }
            }
            .subscribe(onNext: { [weak self] musics in
                var newState = self?.state.value ?? State()
                newState.musics = musics
                self?.state.accept(newState)
            })
            .disposed(by: disposeBag)
    }

    private func fetchMusics() {
        Observable.zip(
            repository.fetchMusics(for: "봄").asObservable(),
            repository.fetchMusics(for: "여름").asObservable(),
            repository.fetchMusics(for: "가을").asObservable(),
            repository.fetchMusics(for: "겨울").asObservable(),
        )
        .subscribe(onNext: { [weak self] spring, summer, autumn, winter in
            self?.musics.accept([spring, summer, autumn, winter])
        })
        .disposed(by: disposeBag)
    }
}

extension HomeViewModel {
    enum Action {
        case viewDidLoad
    }

    struct State {
        var musics = [[MusicDisplayModel]]()
    }

    struct MusicDisplayModel: Hashable {
        let id: Int
        let title: String
        let artist: String
        let albumImagePath: String

        init(from entity: Music, usesOriginalImage: Bool) {
            id = entity.id
            title = entity.title
            artist = entity.artist
            albumImagePath = usesOriginalImage ? entity.albumOriginalImagePath : entity.albumThumbnailImagePath
        }
    }
}
