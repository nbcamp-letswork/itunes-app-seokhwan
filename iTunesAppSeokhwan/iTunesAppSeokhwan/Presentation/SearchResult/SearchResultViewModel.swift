//
//  SearchResultViewModel.swift
//  iTunesAppSeokhwan
//
//  Created by youseokhwan on 5/13/25.
//

import Foundation
import RxSwift
import RxRelay

final class SearchResultViewModel {
    enum Action {
        case viewDidLoad
    }

    struct State {
        let searchText = BehaviorRelay<String>(value: "")
        let items = BehaviorRelay<[SearchResultView.SearchResultItem]>(value: [])
    }

    let action = PublishRelay<Action>()
    let state = State()

    private let useCase: SearchResultUseCase
    private let disposeBag = DisposeBag()

    init(searchText: String, useCase: SearchResultUseCase) {
        state.searchText.accept(searchText)
        self.useCase = useCase
        setBindings()
    }

    private func setBindings() {
        action
            .subscribe(onNext: { [weak self] action in
                switch action {
                case .viewDidLoad:
                    self?.fetchSearchResults()
                }
            })
            .disposed(by: disposeBag)
    }

    private func fetchSearchResults() {
        Task {
            let result = await useCase.fetchSearchResult(for: state.searchText.value)

            switch result {
            case .success(let searchResults):
                let items = searchResults.map {
                    SearchResultView.SearchResultItem(
                        id: $0.id,
                        mediaType: $0.mediaType == .movie ? .movie : .podcast,
                        title: $0.title,
                        author: $0.artist,
                        imagePath: $0.artworkBasePath + "600x600bb.jpg",
                    )
                }
                state.items.accept(items)
            case .failure(let error):
                break // TODO: errorMessage 구현
            }
        }
    }
}
