//
//  DIContainer.swift
//  iTunesAppSeokhwan
//
//  Created by youseokhwan on 5/8/25.
//

import Foundation

final class DIContainer {
    private let service: ITunesAPIService
    private let musicRepository: MusicRepository
    private let searchResultRepository: SearchResultRepository

    init() {
        service = ITunesAPIService()
        musicRepository = MusicRepository(service: service)
        searchResultRepository = SearchResultRepository(service: service)
    }

    func makeHomeViewModel() -> HomeViewModel {
        let useCase = FetchMusicUseCase(repository: musicRepository)
        return HomeViewModel(useCase: useCase)
    }

    func makeSearchResultViewModel(searchText: String) -> SearchResultViewModel {
        let useCase = FetchSearchResultUseCase(repository: searchResultRepository)
        return SearchResultViewModel(searchText: searchText, useCase: useCase)
    }
}
