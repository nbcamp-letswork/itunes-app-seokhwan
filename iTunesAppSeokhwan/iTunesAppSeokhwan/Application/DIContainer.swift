//
//  DIContainer.swift
//  iTunesAppSeokhwan
//
//  Created by youseokhwan on 5/8/25.
//

import Foundation

final class DIContainer {
    private let service: ITunesAPIService
    private let repository: ContentRepository

    init() {
        service = ITunesAPIService()
        repository = ContentRepository(service: service)
    }

    func makeHomeViewModel() -> HomeViewModel {
        let useCase = MusicUseCase(repository: repository)
        return HomeViewModel(useCase: useCase)
    }

    func makeSearchResultViewModel(searchText: String) -> SearchResultViewModel {
        let useCase = SearchResultUseCase(repository: repository)
        return SearchResultViewModel(searchText: searchText, useCase: useCase)
    }

    func makeDetailViewModel(mediaItem: MediaItem) -> DetailViewModel {
        DetailViewModel(mediaItem: mediaItem)
    }
}
