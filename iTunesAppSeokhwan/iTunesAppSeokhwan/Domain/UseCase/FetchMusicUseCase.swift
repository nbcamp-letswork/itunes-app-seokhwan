//
//  FetchMusicUseCase.swift
//  iTunesAppSeokhwan
//
//  Created by youseokhwan on 5/10/25.
//

import Foundation
import RxSwift

final class FetchMusicUseCase {
    private let repository: MusicRepository
    private let disposeBag = DisposeBag()

    init(repository: MusicRepository) {
        self.repository = repository
    }

    func fetchMusic() -> Observable<[[Music]]> {
        Observable.zip(
            repository.fetchMusic(for: "봄").asObservable(),
            repository.fetchMusic(for: "여름").asObservable(),
            repository.fetchMusic(for: "가을").asObservable(),
            repository.fetchMusic(for: "겨울").asObservable(),
        )
        .map { spring, summer, autumn, winter in
            let updatedSpring = spring.map {
                var updated = $0
                updated.albumImagePath = $0.albumImagePath.replaceImageSize(to: 600)
                return updated
            }

            let updatedAutumn = autumn.map {
                var updated = $0
                updated.albumImagePath = $0.albumImagePath.replaceImageSize(to: 600)
                return updated
            }

            return [updatedSpring, summer, updatedAutumn, winter]
        }
    }
}
