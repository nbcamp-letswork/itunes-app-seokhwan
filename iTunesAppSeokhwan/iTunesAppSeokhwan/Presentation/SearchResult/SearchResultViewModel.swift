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

    private let useCase: FetchSearchResultUseCase

    private let searchResults = BehaviorRelay<[SearchResult]>(value: [])
    private let disposeBag = DisposeBag()

    let action = PublishRelay<Action>()
    let state: BehaviorRelay<State>

    init(searchText: String, useCase: FetchSearchResultUseCase) {
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
                $0.map { item in
                    if let movie = item as? Movie {
                        SearchResultView.SearchResultItem(
                            id: movie.id,
                            mediaType: .movie,
                            title: movie.title,
                            author: movie.filmDirector,
                            imagePath: movie.posterImagePath,
                        )
                    } else if let podcast = item as? Podcast {
                        SearchResultView.SearchResultItem(
                            id: podcast.id,
                            mediaType: .podcast,
                            title: podcast.title,
                            author: podcast.creator,
                            imagePath: podcast.posterImagePath,
                        )
                    } else {
                        fatalError()
                    }
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
        useCase.fetchSearchResult(for: state.value.searchText)
            .subscribe(onNext: { [weak self] items in
                self?.searchResults.accept(items)
            })
            .disposed(by: disposeBag)
    }
}
