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
        let items = BehaviorRelay<[[HomeView.HomeItem]]>(value: [])
    }

    let action = PublishRelay<Action>()
    let state = State()

    private let useCase: MusicUseCase
    private let disposeBag = DisposeBag()

    init(useCase: MusicUseCase) {
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
    }

    private func fetchMusic() {
        Task {
            let result = await useCase.fetchMusic()

            switch result {
            case .success(let music):
                let items = music.enumerated().map { (index, element) in
                    element.map {
                        HomeView.HomeItem(
                            id: $0.id,
                            section: HomeView.HomeSection(sectionIndex: index),
                            title: $0.title,
                            artist: $0.artist,
                            albumImagePath: $0.artworkBasePath + "600x600bb.jpg",
                        )
                    }
                }
                state.items.accept(items)
            case .failure(let error):
                break // TODO: errorMessage 구현
            }
        }
    }
}
