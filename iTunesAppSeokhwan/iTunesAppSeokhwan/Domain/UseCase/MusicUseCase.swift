//
//  MusicUseCase.swift
//  iTunesAppSeokhwan
//
//  Created by youseokhwan on 5/15/25.
//

import Foundation

final class MusicUseCase {
    private let repository: ContentRepository

    init(repository: ContentRepository) {
        self.repository = repository
    }

    func fetchMusic() async -> Result<[[MediaItem]], DomainError> {
        async let spring = repository.fetchContents(for: "봄", of: .music)
        async let summer = repository.fetchContents(for: "여름", of: .music)
        async let autumn = repository.fetchContents(for: "가을", of: .music)
        async let winter = repository.fetchContents(for: "겨울", of: .music)
        
        let results = await [spring, summer, autumn, winter]

        // 하나라도 실패할 경우, .failure 반환
        if let failure = results.first(where: {
            if case .failure = $0 { return true }
            return false
        }),
           case let .failure(error) = failure {
            return .failure(error)
        }

        return .success(results.compactMap { try? $0.get() })
    }
}
