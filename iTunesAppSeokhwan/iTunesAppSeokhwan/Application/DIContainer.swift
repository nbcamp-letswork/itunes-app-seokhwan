//
//  DIContainer.swift
//  iTunesAppSeokhwan
//
//  Created by youseokhwan on 5/8/25.
//

import Foundation

final class DIContainer {
    private let service: ITunesAPIService
    private let repository: MusicRepository

    init() {
        service = ITunesAPIService()
        repository = MusicRepository(service: service)
    }

    func makeHomeViewModel() -> HomeViewModel {
        let useCase = FetchMusicUseCase(repository: repository)
        return HomeViewModel(useCase: useCase)
    }
}
