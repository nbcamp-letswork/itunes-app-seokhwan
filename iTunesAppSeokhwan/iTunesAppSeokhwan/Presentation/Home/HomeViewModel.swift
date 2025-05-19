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
    let action = PublishRelay<Action>()
    let state = State()

    private let useCase: MusicUseCase
    private var music = [[MediaItem]]()
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
                case .didTapCell(let indexPath):
                    self?.pushToDetail(with: indexPath)
                }
            })
            .disposed(by: disposeBag)
    }

    private func fetchMusic() {
        Task {
            let result = await useCase.fetchMusic()

            switch result {
            case .success(let music):
                self.music = music
                let items = music.enumerated().map { (index, element) in
                    element.map {
                        // spring, autumn 섹션은 고해상도 이미지 사용
                        let imageFileName = index % 2 == 0 ? "600x600bb.jpg" : "200x200bb.jpg"
                        return Item(
                            id: $0.id,
                            sectionIndex: index,
                            title: $0.title,
                            artist: $0.artist,
                            albumImagePath: $0.artworkBasePath + imageFileName,
                        )
                    }
                }
                state.items.accept(items)
            case .failure(let error):
                state.errorMessage.accept(error.localizedDescription)
            }
        }
    }

    private func pushToDetail(with indexPath: IndexPath) {
        let mediaItem = music[indexPath.section][indexPath.item]
        state.pushToDetail.accept(mediaItem)
    }
}

extension HomeViewModel {
    enum Action {
        case viewDidLoad
        case didTapCell(IndexPath)
    }

    struct State {
        let items = BehaviorRelay<[[Item]]>(value: [])
        let pushToDetail = PublishRelay<MediaItem>()
        let errorMessage = PublishRelay<String>()
    }

    struct Item: Hashable {
        let id: Int
        let sectionIndex: Int
        let title: String
        let artist: String
        let albumImagePath: String

        static func == (lhs: Item, rhs: Item) -> Bool {
            lhs.id == rhs.id && lhs.sectionIndex == rhs.sectionIndex
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
            hasher.combine(sectionIndex)
        }
    }
}
