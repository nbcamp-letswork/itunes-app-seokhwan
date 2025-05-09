//
//  MusicRepository.swift
//  iTunesAppSeokhwan
//
//  Created by youseokhwan on 5/8/25.
//

import Foundation
import RxSwift

final class MusicRepository {
    private let service: ITunesAPIService

    init(service: ITunesAPIService) {
        self.service = service
    }

    func fetchMusics(for term: String) -> Single<[Music]> {
        Single.create { [weak self] single in
            guard let self else { return Disposables.create() }

            Task {
                let result = await self.service.fetchMusics(for: term)

                switch result {
                case .success(let response):
                    single(.success(self.makeMusics(from: response)))
                case .failure(let error):
                    single(.failure(DomainError.networkError(error.localizedDescription)))
                }
            }

            return Disposables.create()
        }
    }

    private func makeMusics(from response: [MusicResponse]) -> [Music] {
        response.map {
            let formatter = ISO8601DateFormatter()
            let releaseDate = formatter.date(from: $0.releaseDate) ?? Date(timeIntervalSince1970: 0)

            return Music(
                id: $0.trackID,
                title: $0.trackName,
                artist: $0.artistName,
                albumTitle: $0.collectionName,
                genre: $0.primaryGenreName,
                releaseDate: releaseDate,
                runningTime: $0.trackTimeMillis,
                albumThumbnailImagePath: $0.artworkURL60,
                albumOriginalImagePath: $0.artworkURL100,
                previewAudioPath: $0.previewURL,
            )
        }
    }
}
