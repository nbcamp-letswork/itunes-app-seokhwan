//
//  ContentRepository.swift
//  iTunesAppSeokhwan
//
//  Created by youseokhwan on 5/15/25.
//

import Foundation
import RxSwift

final class ContentRepository {
    private let service: ITunesAPIService

    init(service: ITunesAPIService) {
        self.service = service
    }

    func fetchContents(
        for term: String,
        of mediaType: ITunesAPIService.MediaType,
    ) async -> Result<[MediaItem], DomainError> {
        let result = await service.fetchContents(for: term, of: mediaType)

        switch result {
        case .success(let dto):
            return .success(makeMediaItems(from: dto, of: mediaType))
        case .failure(let error):
            return .failure(.networkError(error.localizedDescription))
        }
    }

    private func makeMediaItems(
        from dto: [ContentDTO],
        of mediaType: ITunesAPIService.MediaType,
    ) -> [MediaItem] {
        dto.map {
            MediaItem(
                id: $0.trackID,
                mediaType: toDomainMediaType(from: mediaType),
                title: $0.trackName ?? "",
                artist: $0.artistName ?? "",
                collection: $0.collectionName ?? "",
                genre: $0.primaryGenreName ?? "",
                releaseDate: toDomainReleaseDate(from: $0.releaseDate ?? ""),
                runningTime: $0.trackTimeMillis ?? 0,
                description: $0.longDescription ?? "",
                artworkBasePath: toDomainArtworkBasePath(from: $0.artworkURL100 ?? ""),
            )
        }
    }

    private func toDomainMediaType(from mediaType: ITunesAPIService.MediaType) -> MediaItem.MediaType {
        switch mediaType {
        case .music:
            return .music
        case .movie:
            return .movie
        case .podcast:
            return .podcast
        }
    }

    private func toDomainReleaseDate(from dateString: String) -> Date {
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: dateString) ?? Date(timeIntervalSince1970: 0)
    }

    private func toDomainArtworkBasePath(from path: String) -> String {
        let pattern = "\\d+x\\d+bb\\.jpg$"
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return "" }

        return regex.stringByReplacingMatches(
            in: path,
            range: NSRange(path.startIndex..<path.endIndex, in: path),
            withTemplate: "",
        )
    }
}
