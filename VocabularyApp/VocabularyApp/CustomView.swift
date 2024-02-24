//
//  CustomView.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 1/3/24.
//

import UIKit

class ToastView: UIView {
    init(message: String, isGreen: Bool) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = isGreen ? .systemGreen : .systemRed
        layer.cornerRadius = 5
        clipsToBounds = true
        
        let imageName = isGreen ? "checkmark.circle" : "exclamationmark.circle"
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

class EmptyView: UIView {
    init(title: String, message: String) {
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = title
        titleLabel.font = .boldSystemFont(ofSize: 19)
        titleLabel.textColor = .secondaryLabel
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        
        let messageLabel = UILabel()
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.text = message
        messageLabel.textColor = .secondaryLabel
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        
        addSubview(titleLabel)
        addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            messageLabel.topAnchor.constraint(equalToSystemSpacingBelow: titleLabel.bottomAnchor, multiplier: 1),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }    
}
