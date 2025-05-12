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
    enum Action {
        case viewDidLoad
    }

    struct State {
        var music = [[HomeView.HomeItem]]()
    }

    private let useCase: FetchMusicUseCase

    private let music = BehaviorRelay<[[Music]]>(value: [])
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
                    self?.fetchMusic()
                }
            })
            .disposed(by: disposeBag)

        music
            .map {
                $0.enumerated().map { (index, element) in
                    element.map {
                        HomeView.HomeItem(
                            id: $0.id,
                            section: HomeView.HomeSection(sectionIndex: index),
                            title: $0.title,
                            artist: $0.artist,
                            albumImagePath: $0.albumImagePath,
                        )
                    }
                }
            }
            .subscribe(onNext: { [weak self] music in
                var newState = self?.state.value ?? State()
                newState.music = music
                self?.state.accept(newState)
            })
            .disposed(by: disposeBag)
    }

    private func fetchMusic() {
        useCase.fetchMusic()
            .subscribe(onNext: { [weak self] music in
                self?.music.accept(music)
            })
            .disposed(by: disposeBag)
    }
}
