//
//  SearchResultRepository.swift
//  iTunesAppSeokhwan
//
//  Created by youseokhwan on 5/8/25.
//

import Foundation
import RxSwift

final class SearchResultRepository {
    private let service: ITunesAPIService

    init(service: ITunesAPIService) {
        self.service = service
    }

    func fetchMovies(for term: String) -> Single<[Movie]> {
        Single.create { [weak self] single in
            guard let self else { return Disposables.create() }

            Task {
                let result = await self.service.fetchMovies(for: term)

                switch result {
                case .success(let response):
                    single(.success(self.makeMovie(from: response)))
                case .failure(let error):
                    single(.failure(DomainError.networkError(error.localizedDescription)))
                }
            }

            return Disposables.create()
        }
    }

    func fetchPodcasts(for term: String) -> Single<[Podcast]> {
        Single.create { [weak self] single in
            guard let self else { return Disposables.create() }

            Task {
                let result = await self.service.fetchPodcasts(for: term)

                switch result {
                case .success(let response):
                    single(.success(self.makePodcast(from: response)))
                case .failure(let error):
                    single(.failure(DomainError.networkError(error.localizedDescription)))
                }
            }

            return Disposables.create()
        }
    }

    private func makeMovie(from response: [MovieResponse]) -> [Movie] {
        response.map {
            Movie(
                id: $0.trackID,
                title: $0.trackName,
                filmDirector: $0.artistName,
                seriesTitle: $0.collectionName ?? "",
                genre: $0.primaryGenreName,
                releaseDate: Date(iso8601String: $0.releaseDate),
                runningTime: $0.trackTimeMillis,
                posterImagePath: $0.artworkURL,
                previewVideoPath: $0.previewURL,
            )
        }
    }

    private func makePodcast(from response: [PodcastResponse]) -> [Podcast] {
        response.map {
            Podcast(
                id: $0.trackID,
                title: $0.trackName,
                creator: $0.artistName,
                seriesTitle: $0.collectionName,
                genre: $0.primaryGenreName,
                releaseDate: Date(iso8601String: $0.releaseDate),
                runningTime: $0.trackTimeMillis ?? 0,
                posterImagePath: $0.artworkURL,
            )
        }
    }
}
