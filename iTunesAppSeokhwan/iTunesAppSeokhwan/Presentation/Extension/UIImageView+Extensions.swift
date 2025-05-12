//
//  UIImageView+Extensions.swift
//  iTunesAppSeokhwan
//
//  Created by youseokhwan on 5/10/25.
//

import UIKit

extension UIImageView {
    func setImage(from path: String) {
        Task {
            guard let imageData = await ImageLoader.imageData(from: path) else { return }
            image = UIImage(data: imageData)
        }
    }
}
