//
//  DomainError.swift
//  iTunesAppSeokhwan
//
//  Created by youseokhwan on 5/8/25.
//

import Foundation

enum DomainError: LocalizedError {
    case networkError(String)

    var errorDescription: String? {
        switch self {
        case .networkError(let message):
            return message
        }
    }
}
