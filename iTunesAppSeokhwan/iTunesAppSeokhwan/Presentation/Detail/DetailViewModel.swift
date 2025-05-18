//
//  DetailViewModel.swift
//  iTunesAppSeokhwan
//
//  Created by youseokhwan on 5/18/25.
//

import Foundation
import RxSwift
import RxRelay

final class DetailViewModel {
    let action = PublishRelay<Action>()
    let state = State()

    private let mediaItem: MediaItem
    private let disposeBag = DisposeBag()

    init(mediaItem: MediaItem) {
        self.mediaItem = mediaItem
        setBindings()
    }

    private func setBindings() {
        
    }
}

extension DetailViewModel {
    enum Action {
        case viewDidLoad
    }
    
    struct State {
        
    }

    struct DisplayModel {

    }
}
