//
//  Date+Extensions.swift
//  iTunesAppSeokhwan
//
//  Created by youseokhwan on 5/8/25.
//

import Foundation

extension Date {
    init(from iso8601String: String) {
        let formatter = ISO8601DateFormatter()
        self = formatter.date(from: iso8601String) ?? Date(timeIntervalSince1970: 0)
    }
}
