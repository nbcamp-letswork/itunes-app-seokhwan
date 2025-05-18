//
//  ImageLoader.swift
//  iTunesAppSeokhwan
//
//  Created by youseokhwan on 5/10/25.
//

import Foundation
import os

enum ImageLoader {
    static func imageData(from path: String) async -> Data? {
        guard let url = URL(string: path) else {
            return nil
        }

        let request = URLRequest(
            url: url,
            cachePolicy: .returnCacheDataElseLoad,
        )

        if let cacheResponse = URLCache.shared.cachedResponse(for: request) {
            os_log("캐시 이미지 로드: \(url.absoluteString)")
            return cacheResponse.data
        }

        guard let data = try? await URLSession.shared.data(from: url).0 else {
            return nil
        }

        os_log("네트워크 이미지 로드: \(url.absoluteString)")
        return data
    }
}
