//
//  UIImageView+Extensions.swift
//  iTunesAppSeokhwan
//
//  Created by youseokhwan on 5/10/25.
//

import UIKit

extension UIImageView {
    @MainActor
    func setImage(from path: String) {
        Task { [weak self] in
            guard let self,
                  let imageData = await ImageLoader.imageData(from: path) else { return }
            let image = UIImage(data: imageData) ?? .init(systemName: "music.note.list")

            UIView.transition(
                with: self,
                duration: 0.3,
                options: .transitionCrossDissolve,
                animations: {
                    self.image = image
                },
            )
        }
    }
}
