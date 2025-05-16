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
                    Item(
                        id: $0.id,
                        mediaType: $0.mediaType == .movie ? .movie : .podcast,
                        title: $0.title,
                        author: $0.artist,
                        imagePath: $0.artworkBasePath + "600x600bb.jpg",
                    )
                }
                state.items.accept(items)
            case .failure(let error):
                state.errorMessage.accept(error.localizedDescription)
            }
        }
    }
}

extension SearchResultViewModel {
    enum Action {
        case viewDidLoad
    }

    struct State {
        let searchText = BehaviorRelay<String>(value: "")
        let items = BehaviorRelay<[Item]>(value: [])
        let errorMessage = PublishRelay<String>()
    }

    struct Item: Hashable {
        enum MediaType {
            case movie
            case podcast
        }

        let id: Int
        let mediaType: MediaType
        let title: String
        let author: String
        let imagePath: String

        static func == (lhs: Item, rhs: Item) -> Bool {
            lhs.id == rhs.id && lhs.mediaType == rhs.mediaType
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
            hasher.combine(mediaType)
        }
    }
}
