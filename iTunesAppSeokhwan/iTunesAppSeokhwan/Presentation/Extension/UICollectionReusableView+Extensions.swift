//
//  UICollectionReusableView+Extensions.swift
//  iTunesAppSeokhwan
//
//  Created by youseokhwan on 5/9/25.
//

import UIKit

extension UICollectionReusableView {
    enum ViewType {
        case cell
        case header
        case footer
    }

    static var viewType: ViewType {
        if identifier.hasSuffix("Cell") {
            return .cell
        } else if identifier.hasSuffix("Header") {
            return .header
        } else {
            return .footer
        }
    }

    static var identifier: String {
        String(describing: self)
    }
}
