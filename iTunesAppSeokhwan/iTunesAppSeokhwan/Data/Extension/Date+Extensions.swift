//
//  Date+Extensions.swift
//  iTunesAppSeokhwan
//
//  Created by youseokhwan on 5/14/25.
//

import Foundation

extension Date {
    init(iso8601String: String) {
        let formatter = ISO8601DateFormatter()
        self = formatter.date(from: iso8601String) ?? Date(timeIntervalSince1970: 0)
    }
}
