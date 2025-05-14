//
//  FetchSearchResultUseCase.swift
//  iTunesAppSeokhwan
//
//  Created by youseokhwan on 5/14/25.
//

import Foundation
import RxSwift

final class FetchSearchResultUseCase {
    private let repository: SearchResultRepository
    private let disposeBag = DisposeBag()

    init(repository: SearchResultRepository) {
        self.repository = repository
    }

    func fetchSearchResult(for term: String) -> Observable<[SearchResult]> {
        Observable.zip(
            repository.fetchMovies(for: term).asObservable(),
            repository.fetchPodcasts(for: term).asObservable(),
        )
        .map { movies, podcasts in
            let updatedMovies = movies.map {
                var updated = $0
                updated.posterImagePath = $0.posterImagePath.replaceImageSize(to: 600)
                return updated
            }

            return zip(updatedMovies, podcasts).flatMap { movie, podcast in
                [movie as SearchResult, podcast as SearchResult]
            }
        }
    }
}
