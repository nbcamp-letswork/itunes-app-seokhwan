//
//  ITunesAPIService.swift
//  iTunesAppSeokhwan
//
//  Created by youseokhwan on 5/8/25.
//

import Foundation

final class ITunesAPIService {
    private let basePath = "https://itunes.apple.com/search"

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
