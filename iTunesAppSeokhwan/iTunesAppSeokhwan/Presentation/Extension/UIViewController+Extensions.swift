//
//  UIViewController+Extensions.swift
//  iTunesAppSeokhwan
//
//  Created by youseokhwan on 5/15/25.
//

import UIKit

extension UIViewController {
    func presentErrorAlert(with message: String) {
        let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default)
        alert.addAction(action)

        present(alert, animated: true)
    }
}
