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
    private let useCase: FetchMusicUseCase

    private let musics = BehaviorRelay<[[Music]]>(value: [])
    private let disposeBag = DisposeBag()

    let action = PublishRelay<Action>()
    let state = BehaviorRelay<State>(value: State())

    init(useCase: FetchMusicUseCase) {
        self.useCase = useCase
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
                    MusicDisplayModel(entity: element, sectionIndex: index)
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
        useCase.fetchMusics()
            .subscribe(onNext: { [weak self] musics in
                self?.musics.accept(musics)
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
        let id: String
        let title: String
        let artist: String
        let albumImagePath: String

        init(entity: Music, sectionIndex: Int) {
            id = "\(entity.id)\(sectionIndex)"
            title = entity.title
            artist = entity.artist
            albumImagePath = entity.albumImagePath
        }
    }
}
