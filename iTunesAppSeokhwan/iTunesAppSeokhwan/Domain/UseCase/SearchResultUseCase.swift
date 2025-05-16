//
//  SearchResultUseCase.swift
//  iTunesAppSeokhwan
//
//  Created by youseokhwan on 5/15/25.
//

import Foundation

final class SearchResultUseCase {
    private let repository: ContentRepository

    init(repository: ContentRepository) {
        self.repository = repository
    }

    func fetchSearchResult(for term: String) async -> Result<[MediaItem], DomainError> {
        async let movies = repository.fetchContents(for: term, of: .movie)
        async let podcasts = repository.fetchContents(for: term, of: .podcast)

        let results = await [movies, podcasts]

        // 하나라도 실패할 경우, .failure 반환
        if let failure = results.first(where: {
            if case .failure = $0 { return true }
            return false
        }),
           case let .failure(error) = failure {
            return .failure(error)
        }

        /*
         shuffle은 UI 표현을 위해 임시로 사용
         이후 인기순 혹은 관련성순으로 정렬할 수 있으면 대체
         */
        let mediaItems = results.compactMap { try? $0.get() }.flatMap { $0 }
        let shuffled = mediaItems.shuffled()

        return .success(shuffled)
    }
}
