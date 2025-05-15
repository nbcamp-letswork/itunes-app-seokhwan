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

        return .success(results.compactMap { try? $0.get() }.flatMap { $0 })
    }
}
