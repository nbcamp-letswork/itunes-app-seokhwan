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
        var musics = [[HomeView.HomeItem]]()
    }

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
