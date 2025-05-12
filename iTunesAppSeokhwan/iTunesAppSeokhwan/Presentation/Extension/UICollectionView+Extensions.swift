//
//  UICollectionView+Extensions.swift
//  iTunesAppSeokhwan
//
//  Created by youseokhwan on 5/11/25.
//

import UIKit

extension UICollectionView {
    func register(_ metatypes: UICollectionReusableView.Type...) {
        metatypes.forEach { metatype in
            switch metatype.viewType {
            case .cell:
                register(
                    metatype,
                    forCellWithReuseIdentifier: metatype.identifier,
                )
            default:
                let elementKind = metatype.viewType == .header
                    ? UICollectionView.elementKindSectionHeader
                    : UICollectionView.elementKindSectionFooter
                register(
                    metatype,
                    forSupplementaryViewOfKind: elementKind,
                    withReuseIdentifier: metatype.identifier,
                )
            }
        }
    }
}
