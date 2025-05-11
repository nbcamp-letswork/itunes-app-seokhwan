//
//  ImageLoader.swift
//  iTunesAppSeokhwan
//
//  Created by youseokhwan on 5/10/25.
//

import Foundation


enum ImageLoader {
    static func imageData(from path: String) async -> Data? {
        guard let url = URL(string: path),
              let data = try? await URLSession.shared.data(from: url).0 else {
            return nil
        }
        return data
    }
}
