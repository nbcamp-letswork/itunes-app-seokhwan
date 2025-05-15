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
        let searchText: String
        var items = [SearchResultView.SearchResultItem]()
    }

    private let useCase: SearchResultUseCase

    private let searchResults = BehaviorRelay<[MediaItem]>(value: [])
    private let disposeBag = DisposeBag()

    let action = PublishRelay<Action>()
    let state: BehaviorRelay<State>

    init(searchText: String, useCase: SearchResultUseCase) {
        self.useCase = useCase
        state = .init(value: State(searchText: searchText))
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

        searchResults
            .map {
                $0.map {
                    SearchResultView.SearchResultItem(
                        id: $0.id,
                        mediaType: $0.mediaType == .movie ? .movie : .podcast,
                        title: $0.title,
                        author: $0.artist,
                        imagePath: $0.artworkBasePath + "600x600bb.jpg",
                    )
                }
            }
            .subscribe(onNext: { [weak self] items in
                guard var newState = self?.state.value else { fatalError() }
                newState.items = items
                self?.state.accept(newState)
            })
            .disposed(by: disposeBag)
    }

    private func fetchSearchResults() {
        Task {
            let result = await useCase.fetchSearchResult(for: state.value.searchText)

            if case let .success(items) = result {
                self.searchResults.accept(items)
            }
        }
    }
}
