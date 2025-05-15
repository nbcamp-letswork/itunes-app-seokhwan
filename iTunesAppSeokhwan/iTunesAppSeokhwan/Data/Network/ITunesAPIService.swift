//
//  ITunesAPIService.swift
//  iTunesAppSeokhwan
//
//  Created by youseokhwan on 5/8/25.
//

import Foundation

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

        guard let (data, response) = try? await URLSession.shared.data(from: url),
              let httpResponse = response as? HTTPURLResponse else {
            return .failure(.noData)
        }

        guard (200..<300).contains(httpResponse.statusCode) else {
            return .failure(.requestFailed(statusCode: httpResponse.statusCode))
        }

        guard let resultsResponse = try? JSONDecoder().decode(ContentsDTO.self, from: data) else {
            return .failure(.decodingFailed)
        }

        return .success(resultsResponse.results)
    }

    func fetchMusic(for term: String) async -> Result<[MusicResponse], NetworkError> {
        let urlString = basePath + "?media=music&term=\(term)&entity=song&limit=12"
        guard let url = URL(string: urlString) else {
            return .failure(.invalidURL)
        }

        guard let (data, response) = try? await URLSession.shared.data(from: url),
              let httpResponse = response as? HTTPURLResponse else {
            return .failure(.noData)
        }

        guard (200..<300).contains(httpResponse.statusCode) else {
            return .failure(.requestFailed(statusCode: httpResponse.statusCode))
        }

        guard let resultsResponse = try? JSONDecoder().decode(MusicResultsResponse.self, from: data) else {
            return .failure(.decodingFailed)
        }

        return .success(resultsResponse.results)
    }

    func fetchMovies(for term: String) async -> Result<[MovieResponse], NetworkError> {
        let urlString = basePath + "?media=movie&term=\(term)&entity=movie&limit=5"
        guard let url = URL(string: urlString) else {
            return .failure(.invalidURL)
        }

        guard let (data, response) = try? await URLSession.shared.data(from: url),
              let httpResponse = response as? HTTPURLResponse else {
            return .failure(.noData)
        }

        guard (200..<300).contains(httpResponse.statusCode) else {
            return .failure(.requestFailed(statusCode: httpResponse.statusCode))
        }

        guard let resultsResponse = try? JSONDecoder().decode(MovieResultsResponse.self, from: data) else {
            return .failure(.decodingFailed)
        }

        return .success(resultsResponse.results)
    }

    func fetchPodcasts(for term: String) async -> Result<[PodcastResponse], NetworkError> {
        let urlString = basePath + "?media=podcast&term=\(term)&entity=podcast&limit=5"
        guard let url = URL(string: urlString) else {
            return .failure(.invalidURL)
        }

        guard let (data, response) = try? await URLSession.shared.data(from: url),
              let httpResponse = response as? HTTPURLResponse else {
            return .failure(.noData)
        }

        guard (200..<300).contains(httpResponse.statusCode) else {
            return .failure(.requestFailed(statusCode: httpResponse.statusCode))
        }

        guard let resultsResponse = try? JSONDecoder().decode(PodcastResultsResponse.self, from: data) else {
            return .failure(.decodingFailed)
        }

        return .success(resultsResponse.results)
    }
}
