//
//  ITunesAPIService.swift
//  iTunesAppSeokhwan
//
//  Created by youseokhwan on 5/8/25.
//

import Foundation
import os

final class ITunesAPIService {
    enum MediaType {
        case music
        case movie
        case podcast

        var urlParameters: String {
            "?media=\(media)&entity=\(entity)&limit=\(limit)"
        }

        private var media: String {
            switch self {
            case .music:
                return "music"
            case .movie:
                return "movie"
            case .podcast:
                return "podcast"
            }
        }

        private var entity: String {
            switch self {
            case .music:
                return "song"
            case .movie:
                return "movie"
            case .podcast:
                return "podcast"
            }
        }

        private var limit: Int {
            switch self {
            case .music:
                return 12
            case .movie:
                return 5
            case .podcast:
                return 5
            }
        }
    }

    private let basePath = "https://itunes.apple.com/search"

    func fetchContents(
        for term: String,
        of mediaType: MediaType,
    ) async -> Result<[ContentDTO], NetworkError> {
        let urlString = basePath + mediaType.urlParameters + "&term=\(term)"
        guard let url = URL(string: urlString) else {
            return .failure(.invalidURL)
        }

        let request = URLRequest(
            url: url,
            cachePolicy: .returnCacheDataElseLoad,
        )

        if let cachedResponse = URLCache.shared.cachedResponse(for: request) {
            os_log("캐시 데이터 로드: \(url.absoluteString)")
            return decode(from: cachedResponse.data)
        }

        guard let (data, response) = try? await URLSession.shared.data(from: url),
              let httpResponse = response as? HTTPURLResponse else {
            return .failure(.noData)
        }

        guard (200..<300).contains(httpResponse.statusCode) else {
            return .failure(.requestFailed(statusCode: httpResponse.statusCode))
        }

        os_log("네트워크 데이터 로드: \(url.absoluteString)")
        return decode(from: data)
    }

    private func decode(from data: Data) -> Result<[ContentDTO], NetworkError> {
        guard let resultsResponse = try? JSONDecoder().decode(ContentsDTO.self, from: data) else {
            return .failure(.decodingFailed)
        }
        return .success(resultsResponse.results)
    }
}
