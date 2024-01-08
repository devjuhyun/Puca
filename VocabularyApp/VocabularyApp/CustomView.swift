//
//  CustomView.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 1/3/24.
//

import UIKit

class ToastView: UIView {
    init(message: String, color: UIColor = .systemRed, imageName: String = "exclamationmark.circle") {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = color
        layer.cornerRadius = 5
        clipsToBounds = true
        
        let toastImageView = UIImageView(image: UIImage(systemName: imageName)?.withTintColor(.white, renderingMode: .alwaysOriginal))
        toastImageView.translatesAutoresizingMaskIntoConstraints = false
        let toastLabel = UILabel()
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastLabel.textColor = .white
        toastLabel.font = .boldSystemFont(ofSize: 14)
        toastLabel.textAlignment = .left
        toastLabel.text = message
        
        addSubview(toastImageView)
        addSubview(toastLabel)
        
        NSLayoutConstraint.activate([
            toastImageView.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 1),
            toastImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            toastLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: toastImageView.trailingAnchor, multiplier: 1),
            toastLabel.centerYAnchor.constraint(equalTo: toastImageView.centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
