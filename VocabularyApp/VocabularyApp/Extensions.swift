//
//  Extensions.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 11/11/23.
//

import UIKit

extension UIViewController {
    func showToast(message : String, color: UIColor) {
        let toastView = UIView()
        toastView.translatesAutoresizingMaskIntoConstraints = false
        toastView.backgroundColor = color
        toastView.layer.cornerRadius = 5
        toastView.clipsToBounds = true
        
        let toastImageView = UIImageView(image: UIImage(systemName: "checkmark.circle.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal))
        toastImageView.translatesAutoresizingMaskIntoConstraints = false
        let toastLabel = UILabel()
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastLabel.textColor = .white
        toastLabel.font = .boldSystemFont(ofSize: 14)
        toastLabel.textAlignment = .left
        toastLabel.text = message
        
        toastView.addSubview(toastImageView)
        toastView.addSubview(toastLabel)
        view.addSubview(toastView)
        
        NSLayoutConstraint.activate([
            toastImageView.leadingAnchor.constraint(equalToSystemSpacingAfter: toastView.leadingAnchor, multiplier: 1),
            toastImageView.centerYAnchor.constraint(equalTo: toastView.centerYAnchor),
            
            toastLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: toastImageView.trailingAnchor, multiplier: 1),
            toastLabel.centerYAnchor.constraint(equalTo: toastImageView.centerYAnchor),
            
            toastView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            toastView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: toastView.trailingAnchor, multiplier: 1),
            toastView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toastView.heightAnchor.constraint(equalToConstant: 30)
        ])
            
        UIView.animate(withDuration: 1, delay: 1, options: .curveEaseOut, animations: {
            toastView.alpha = 0.0
        }, completion: {(isCompleted) in
            toastView.removeFromSuperview()
        })
    }
}

extension UINavigationItem {
    func setBackBarButtonItem() {
        let button = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        button.tintColor = .label
        backBarButtonItem = button
    }
}
