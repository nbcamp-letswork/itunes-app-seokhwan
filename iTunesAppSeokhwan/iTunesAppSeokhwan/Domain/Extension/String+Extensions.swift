//
//  String+Extensions.swift
//  iTunesAppSeokhwan
//
//  Created by youseokhwan on 5/14/25.
//

import Foundation

extension String {
    func replaceImageSize(to pixel: Int) -> String {
        let pattern = #"\d+x\d+bb\.jpg$"#
        let replacement = "\(pixel)x\(pixel)bb.jpg"
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return self }

        return regex.stringByReplacingMatches(
            in: self,
            range: NSRange(startIndex..<endIndex, in: self),
            withTemplate: replacement,
        )
    }
}
