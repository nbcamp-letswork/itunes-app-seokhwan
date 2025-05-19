//
//  ContentRepository.swift
//  iTunesAppSeokhwan
//
//  Created by youseokhwan on 5/19/25.
//

import Foundation

protocol ContentRepository {
    func fetchContents(
        for term: String,
        of mediaType: ITunesAPIService.MediaType,
    ) async -> Result<[MediaItem], DomainError>
}
