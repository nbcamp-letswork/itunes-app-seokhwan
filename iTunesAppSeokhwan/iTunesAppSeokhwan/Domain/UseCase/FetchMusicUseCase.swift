//
//  FetchMusicUseCase.swift
//  iTunesAppSeokhwan
//
//  Created by youseokhwan on 5/10/25.
//

import Foundation
import RxSwift

final class FetchMusicUseCase {
    private let repository: MusicRepository
    private let disposeBag = DisposeBag()

    init(repository: MusicRepository) {
        self.repository = repository
    }

    func fetchMusics() -> Observable<[[Music]]> {
        Observable.zip(
            repository.fetchMusics(for: "봄").asObservable(),
            repository.fetchMusics(for: "여름").asObservable(),
            repository.fetchMusics(for: "가을").asObservable(),
            repository.fetchMusics(for: "겨울").asObservable(),
        )
        .map { [weak self] spring, summer, autumn, winter in
            guard let self else { return [] }

            let updatedSpring = spring.map {
                var updated = $0
                updated.albumImagePath = self.replaceImageSize(in: $0.albumImagePath, to: 600)
                return updated
            }

            let updatedAutumn = autumn.map {
                var updated = $0
                updated.albumImagePath = self.replaceImageSize(in: $0.albumImagePath, to: 600)
                return updated
            }

            return [updatedSpring, summer, updatedAutumn, winter]
        }
    }

    private func replaceImageSize(in path: String, to pixel: Int) -> String {
        let pattern = #"\d+x\d+bb\.jpg$"#
        let replacement = "\(pixel)x\(pixel)bb.jpg"
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return path }

        return regex.stringByReplacingMatches(
            in: path,
            range: NSRange(path.startIndex..<path.endIndex, in: path),
            withTemplate: replacement,
        )
    }
}
