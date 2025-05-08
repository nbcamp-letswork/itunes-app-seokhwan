//
//  NetworkError.swift
//  iTunesAppSeokhwan
//
//  Created by youseokhwan on 5/8/25.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case noData
    case requestFailed(statusCode: Int)
    case decodingFailed

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "유효하지 않은 URL입니다."
        case .noData:
            return "데이터가 존재하지 않습니다."
        case .requestFailed(let statusCode):
            return "네트워크 요청에 실패했습니다. 상태 코드: \(statusCode)"
        case .decodingFailed:
            return "데이터 디코딩에 실패했습니다."
        }
    }
}
